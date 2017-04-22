var express = require('express'),
    app = express(),
    sql = require('mysql'),
    morgan = require('morgan'),
    cookieParser = require('cookie-parser'),
    bodyParser = require('body-parser'),
    session = require('express-session'),
    path = require('path'),
    fs = require('fs'),
    appDetails = JSON.parse(fs.readFileSync('./appDetailsOpenChain.json', 'utf-8')),
    bcrypt = require('bcrypt'),
    schedule = require("node-schedule"),
    openchain = require("openchain"),
    bitcore = require("bitcore-lib"),
    moment = require("moment");

const saltRounds = 10;


/*
  Openchain Setup
 */

// Load a private key
var privateKey = new bitcore.HDPrivateKey(appDetails.openchainKey);


/*
  DB Setup
*/

var sqlConnection = sql.createConnection({
    host: appDetails.sqlDbUrl,
    user: appDetails.sqlDbUser,
    password: appDetails.sqlDbPassword,
    database: appDetails.sqlDbName
});

// Handle connecting to database plus disconnection errors
(function connectToDatabase() {
    sqlConnection.connect(function(err){
        if(err){
            console.error(err);
            // Wait 3 seconds before attempting to reconnect
            setTimeout(connectToDatabase, 3000)
        }
    });

    sqlConnection.on("error", function (err) {
        console.error(err);

        sqlConnection.destroy();

        sqlConnection = sql.createConnection({
            host: appDetails.sqlDbUrl,
            user: appDetails.sqlDbUser,
            password: appDetails.sqlDbPassword,
            database: appDetails.sqlDbName
        });

        // Try to reconnect if a disconnection
        if (err.code === "PROTOCOL_CONNECTION_LOST" || "ECONNRESET") {
            connectToDatabase();
        }
    })
})();


/*
  Schedule a job to run and update the internal statements daily at 16:40
 */

var rule = new schedule.RecurrenceRule();
rule.hour = 16;
rule.minute = 40;

var j = schedule.scheduleJob(rule, function(){
    // these may need to be promised...
    updateShareStatement();
    updateCashStatement();
    updateNavValue();
});

function updateShareStatement() {

    sqlConnection.query("CALL get_owned_stocks()", onSqlQueryResponse);

    function onSqlQueryResponse(err, rows) {
        if (err) {
            console.error(err);
        }
        else {
            var promises = [];
            rows[0].forEach(function (row) {
                // if more than one of the stock is held
                if (row.Amount !== 0) {
                    // create a promise which will resolve how much of the stock (in monetary terms) we have
                    promises.push(new Promise(function (resolve, reject) {
                        https.get({
                            host: "www.quandl.com", path: "/api/v3/datasets/LSE/" + row["Ticker_Symbol"] +
                            ".json?limit=1"
                        }, function onStockDataResponse(response) {
                            var body = '';
                            response.setEncoding('utf8');

                            // another chunk of data has been received, so append it to `body`
                            response.on('data', function (chunk) {
                                body += chunk;
                            });

                            // the whole response has been received
                            response.on('end', function () {
                                var parsed = JSON.parse(body);
                                var stockValue = parsed.dataset.data[0][parsed.dataset["column_names"].indexOf("Last Close")];
                                resolve(stockValue * row["Amount"]);
                            });
                        });
                    }));
                }
            });
            // when all stock values have been resolved or rejected
            Promise.all(promises).then(function(portfolioValues) {
                var totalPortfolioValue = 0;
                portfolioValues.forEach(function (portfolioValue) {
                    totalPortfolioValue += portfolioValue;
                });
                // for now, the Account_ID is always 0
                sqlConnection.query('INSERT INTO asset_share_statement VALUES (?, ?, ?);', [0, new Date(), totalPortfolioValue], function (err) {
                    if(err) {
                        console.log(err);
                    }
                })
            });
        }
    }
}

function updateCashStatement() {
    sqlConnection.query("CALL update_cash_statement()", function(err) {
        if(err) {
            console.error(err);
        }
    });
}

function updateNavValue() {
    sqlConnection.query("CALL update_nav_value()", function (err) {
        if(err) {
            console.error(err);
        }
    })
}


/*
  HTTPS Setup
*/

var https = require('https');
var httpsPort = 3443;

var options = {
    key: fs.readFileSync(appDetails.httpsKey),
    cert: fs.readFileSync(appDetails.httpsCert)
};

var secureServer = https.createServer(options, app).listen(httpsPort);

app.set('port_https', httpsPort);

// Redirect all insecure requests
app.all('*', function(req, res, next) {
    if (req.secure) {
        return next();
    }
    res.redirect('https://' + req.hostname + req.url);
});


/*
  Express Setup
 */

// Make files in app directory available
app.use(express.static(__dirname + '/app'));

// Make nodejs modules available
app.use(express.static(__dirname + '/node_modules'));

// Use body parser so information can be grabbed from POST and/or URL parameters
app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(bodyParser.json());

// Use morgan to log requests to the console
app.use(morgan('dev'));

// Use cookieParser for handling of cookies
app.use(cookieParser());

// Use express-session for user login sessions
app.use(session({
    secret: appDetails.secret,
    name: 'sessionId', // give the cookie a different name from the standard
    resave: false, // don't save session if unmodified
    saveUninitialized: false, // don't create session until something stored
    cookie: {secure: true} // https
}));

function restrict(req, res, next) {
    if (req.session.user) {
        next();
    } else {
        req.session.error = 'Access denied!';
        res.status(401).send()
    }
}

/*
  API routes
 */

var apiRoutes = express.Router();

// log in route
apiRoutes.post('/login', function (req, res) {
    authenticate(req, res, handleAuthenticationResponse);
});

/**
 * Authentication function
 *
 * Checks the db for matching username and hash combination, calls the supplied callback with appropriate arguments.
 *
 * @param req - the request received by the web server
 * @param res - the response to be sent by the web server
 * @param callback - function(err, user) -> user is the email of the authenticated user
 */
function authenticate(req, res, callback) {

    const userRequestedUsername = req.body.username.toLocaleLowerCase();

    // Is username in DB?
    sqlConnection.query("SELECT * FROM account_auth WHERE username = ?", userRequestedUsername, function (err, rows) {
        if (err) {
            // DB error
            return callback(err, null, req, res);
        }
        else if (!(rows === undefined || rows.length === 0)) {
            // Hashed passwords match?
            return bcrypt.compare(req.body.password, rows[0]["Password_Hash"], function (err, matchingHash) {
                if (err) {
                    return callback(err, null, req, res);
                }
                else if (matchingHash) {
                    return callback(null, userRequestedUsername, req, res);
                }
                else {
                    err = {};
                    err.statusCode = 401;
                    return callback(err, null, req, res);
                }
            })
        }
        else {
            err = {};
            err.statusCode = 401;
            return callback(err, null, req, res);
        }
    })
}

function handleAuthenticationResponse(err, user, req, res) {
    if (err) {
        if (err.statusCode === 401) {
            res.status(401).send();
        }
        else {
            console.error(err);
            res.status(500).send();
        }
    }
    else if (user) {
        req.session.regenerate(function () {
            req.session.user = user;
            res.status(200).send();
        });
    }
}

apiRoutes.get('/logout', function(req, res) {
    // destroy the user's session to log them out
    // will be re-created next request
    req.session.destroy(function(){
        res.status(200).send();
    });
});

apiRoutes.post('/signup', function (req, routeRes) {

    bcrypt.hash(req.body.password, saltRounds, function(err, hash) {

        var newPrivateKey = new bitcore.HDPrivateKey();

        // create a new simple user - make sure on sign up, username is transformed to lower case. Similar check on
        // login
        var user = {Username: req.body.username.toLocaleLowerCase(), Password_Hash: hash, Openchain_Key:
            newPrivateKey.xprivkey};

        // insert user (automatic sanitisation)
        sqlConnection.query("INSERT INTO account_auth SET ?", user, function(err) {
            if(err){
                // handle case of duplicate email entry
                if(err.code === "ER_DUP_ENTRY") {
                    routeRes.status(409).send({reason: err.code});
                }
                else {
                    console.error(err);
                    routeRes.status(500).send({reason: "dbInsertionError"});
                }
            }
            else {
                var address = newPrivateKey.publicKey.toAddress();
                var newCustomerEmail = req.body.username.toLocaleLowerCase().replace("@", ",");

                // Calculate the accounts corresponding to the private key
                var dataPath = "/aka/" + newCustomerEmail + "/";
                var recordName = "goto";
                var storedData = "/users/" + address + "/";

                // Create an Openchain client and signer
                var client = new openchain.ApiClient("http://localhost:8080/");
                var signer = new openchain.MutationSigner(privateKey);

                // Initialize the client
                client.initialize()
                    .then(function () {
                        // Retrieve the record being modified
                        return client.getDataRecord(dataPath, recordName)
                    })
                    .then(function (dataRecord) {
                        // Encode the data into a ByteBuffer
                        var newValue = openchain.encoding.encodeString(storedData);

                        // Create a new transaction builder
                        return new openchain.TransactionBuilder(client)
                        // Add the key to the transaction builder
                            .addSigningKey(signer)
                            // Modify the record
                            .addRecord(dataRecord.key, newValue, dataRecord.version)
                            // Submit the transaction
                            .submit();
                    })
                    .then(function (result) {

                        // Create another transaction to modify the account permissions
                        recordName = "acl";
                        storedData = openchain.encoding.encodeString("[{\"subjects\": [ { \"addresses\": [ ], \"required\": 0 } ],\"permissions\": { \"account_modify\": \"Permit\", \"account_create\": \"Permit\" }},{\"subjects\": [ { \"addresses\": [" + address + " ], \"required\": 1 } ],\"permissions\": { \"account_spend\": \"Permit\" }}]")

                        // Initialize the client
                        client.initialize()
                            .then(function () {
                                // Retrieve the record being modified
                                return client.getDataRecord(dataPath, recordName)
                            })
                            .then(function (dataRecord) {
                                // Encode the data into a ByteBuffer
                                var newValue = openchain.encoding.encodeString(storedData);

                                // Create a new transaction builder
                                return new openchain.TransactionBuilder(client)
                                // Add the key to the transaction builder
                                    .addSigningKey(signer)
                                    // Modify the record
                                    .addRecord(dataRecord.key, newValue, dataRecord.version)
                                    // Submit the transaction
                                    .submit();
                            })
                            .then(function (result) {

                                // also login
                                authenticate(req, routeRes, handleAuthenticationResponse);
                            });
                    }, function (err) {
                        console.log(err);
                    });
            }
        });
    });
});

apiRoutes.post("/addFunds", restrict, function (req, res) {
    sqlConnection.query("SELECT Openchain_Key FROM account_auth WHERE username = ?", req.session.user, deriveAddress);

    function deriveAddress(err, rows) {
        if (err) {
            console.error(err);
            res.status(500).send({reason: "DB query error"})
        }
        else {
            var userPrivateKey = bitcore.HDPrivateKey(rows[0]["Openchain_Key"]);

            var walletPath = "/user/" + userPrivateKey.publicKey.toAddress() + "/";
            var issuancePath = "/stockchain/";
            var assetPath = "/asset/unit/";

            // Corresponds to £100.00 with a nav of 1
            var issuanceAmount = 10000;

            // Create an Openchain client and signer
            var client = new openchain.ApiClient("http://localhost:8080/");
            var signer = new openchain.MutationSigner(privateKey);

            // Initialize the client
            client.initialize()
                .then(function () {
                    // Create a new transaction builder
                    return new openchain.TransactionBuilder(client)
                    // Add the key to the transaction builder
                        .addSigningKey(signer)
                        // Take 10000 units of the asset from the issuance path
                        .updateAccountRecord(issuancePath, assetPath, -issuanceAmount);
                })
                .then(function (transactionBuilder) {
                    // Add 10000 units of the asset to the target wallet path
                    return transactionBuilder.updateAccountRecord(walletPath, assetPath, issuanceAmount);
                })
                .then(function (transactionBuilder) {
                    // Submit the transaction
                    return transactionBuilder.submit();
                })
                .then(function (result) {
                    sqlConnection.query("call purchase_units(?, ?)", [issuanceAmount/100, userPrivateKey.xprivkey], function (err) {
                        if (err) {
                            console.error(err);
                            res.status(500).send({reason: "DB query error"});
                        }
                        else {
                            res.status(200).send();
                        }
                    });
                });
        }
    }
});

/**
 * Add funds to the current account. For testing this route simply adds £100
 * to the invoking account when asked.
 */
apiRoutes.post("/addFunds", restrict, function (req, res) {
    sqlConnection.query("call purchase_units(100, ?)", req.session.user, function (err, rows) {
        if (err) {
            console.error(err);
            res.status(500).send({reason: "Internal DB error"});
        }
        else {
            res.status(200).send();
        }
    })
});

/**
 * Route used to make a transaction between user accounts
 *
 *
 */
apiRoutes.post("/makeTransaction", restrict, function (req, res) {

    // Nothing can be done if we don't have the data/it isn't correct
    if(!req.body.username) {
        return res.status(400).send({reason: "No recipient email given", errCode: "USER_ERR"});
    }
    else if (!req.body.amount) {
        return res.status(400).send({reason: "No amount specified", errCode: "AMT_ERR"});
    }
    else if(!(typeof(req.body.amount) === "number")) {
        return res.status(400).send({reason: "Amount given is not a number", errCode: "AMT_ERR"});
    }
    else if(!(typeof(req.body.username) === "string")) {
        return res.status(400).send({reason: "Username given is not a string", errCode: "USER_ERR"});
    }
    else if(!Number.isInteger(req.body.amount * 100)) {
        return res.status(400).send({reason: "Amount given has more than two decimal places", errCode: "AMT_ERR"});
    }
    else if(req.body.amount < 0) {
        return res.status(400).send({reason: "Amount given is a negative value", errCode: "AMT_ERR"});
    }

    // Semantic problems
    if (req.body.username === req.session.user) {
        return res.status(400).send({reason: "Recipient's username is same as sender's username", errCode: "USER_ERR"});
    }

    // Check recipient is a valid user
    sqlConnection.query("SELECT * FROM account_auth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            console.log(err);
            return res.status(500).send({reason: "DB query error"});
        }

        if(rows.length === 0) {
            return res.status(400).send({reason: "No such user " + req.body.username, errCode: "USER_ERR"});
        }

        var recipientKey = new bitcore.HDPrivateKey(rows[0]["Openchain_Key"]);

        sqlConnection.query("SELECT * FROM account_auth WHERE Username = ?", req.session.user, function (err, rows) {
            if (err) {
                console.log(err);
                return res.status(500).send({reason: "DB query error"});
            }

            if (rows.length === 0) {
                return res.status(400).send({reason: "No such user " + req.session.user, errCode: "USER_ERR"});
            }

            var client = new openchain.ApiClient("http://localhost:8080/");
            var userPrivateKey = new bitcore.HDPrivateKey(rows[0]["Openchain_Key"]);
            var address = userPrivateKey.publicKey.toAddress();

            client.getAccountRecord(
                // Account path
                "/user/" + address + "/",
                // Asset path
                "/asset/unit/")
                .then(function (result) {
                    sqlConnection.query("select Quote from nav_value order by Quote_Date desc limit 1", function (err, rows) {
                        if (err) {
                            console.error(err);
                            res.status(500).send({reason: "Problem fetching NAV from DB"});
                        }
                        else {

                            var currencyBalance = rows[0].Quote * result.balance/100;

                            // Not enough money in account
                            if (currencyBalance < req.body.amount) {
                                return res.status(400).send({reason: "Insufficient funds to make transfer of " + req.body.amount + " to " +
                                req.body.username, errCode: "AMT_ERR", amount: req.body.amount});
                            }

                            var issuancePath = "/user/" + userPrivateKey.publicKey.toAddress() + "/";
                            var walletPath = "/user/" + recipientKey.publicKey.toAddress() + "/";
                            var assetPath = "/asset/unit/";

                            // May not play nicely without proper decimal support...
                            var issuanceAmount = req.body.amount * 100/rows[0].Quote;

                            // Create an Openchain client and signer
                            var client = new openchain.ApiClient("http://localhost:8080/");
                            var signer = new openchain.MutationSigner(privateKey);

                            // Initialize the client
                            client.initialize()
                                .then(function () {
                                    // Create a new transaction builder
                                    return new openchain.TransactionBuilder(client)
                                    // Add the key to the transaction builder
                                        .addSigningKey(signer)
                                        // Take units of the asset from the issuance path
                                        .updateAccountRecord(issuancePath, assetPath, -issuanceAmount);
                                }, function (err) {
                                    console.error(err);
                                    return res.status(500);
                                })
                                .then(function (transactionBuilder) {
                                    // Add units of the asset to the target wallet path
                                    return transactionBuilder.updateAccountRecord(walletPath, assetPath, issuanceAmount);
                                }, function (err) {
                                    console.error(err);
                                    return res.status(500);
                                })
                                .then(function (transactionBuilder) {
                                    // Submit the transaction
                                    return transactionBuilder.submit();
                                }, function (err) {
                                    console.error(err);
                                    return res.status(500);
                                })
                                .then(function (result) {
                                    // Functionify?
                                    client.getAccountRecord(
                                        // Account path
                                        "/user/" + address + "/",
                                        // Asset path
                                        "/asset/unit/")
                                        .then(function (result) {
                                            sqlConnection.query("select Quote from nav_value order by Quote_Date desc limit 1", function (err, rows) {
                                                if (err) {
                                                    console.error(err);
                                                    res.status(500).send({reason: "Problem fetching NAV from DB"});
                                                }
                                                else {
                                                    var currencyBalance = rows[0].Quote * result.balance/100;
                                                    res.status(200).send({
                                                        stock: {balance: result.balance.toString()},
                                                        // Placeholder
                                                        currency: {balance: currencyBalance.toString()}
                                                    });
                                                }
                                            });
                                        });
                                }, function (err) {
                                    console.error(err);
                                    return res.status(500);
                                });
                        }
                    });
                });
        });
    });
});

/**
 * Gets the logged in user's transactions
 */
apiRoutes.get("/getAccountTransactions", restrict, function (req, res) {

    var client = new openchain.ApiClient("http://localhost:8080/");

    // Get current user
    sqlConnection.query("SELECT * FROM account_auth WHERE Username = ?", req.session.user, function (err, rows) {
        if (err) {
            console.log(err);
            return res.status(500).send({reason: "DB query error"});
        }

        if (rows.length === 0) {
            return res.status(400).send({reason: "No such user " + req.session.user, errCode: "USER_ERR"});
        }

        var client = new openchain.ApiClient("http://localhost:8080/");
        var userPrivateKey = new bitcore.HDPrivateKey(rows[0]["Openchain_Key"]);
        var address = userPrivateKey.publicKey.toAddress();

        // Get the record representing the balance (in Units) of the current user's account
        client.getAccountRecord("/user/" + address + "/", "/asset/unit/").then(function (accountRecord) {

            // Get the hashes of all changes (mutations) to the account
            client.getRecordMutations(accountRecord.key).then(function (mutations) {

                var transactions = [];

                // For each mutation, get the transaction that produced it
                var transactionRequests = mutations.map(function (item) {
                    return new Promise(function (resolve) {
                        client.getTransaction(item).then(function(transaction) {
                            transactions.push(transaction);
                            resolve();
                        });
                    });
                });
                Promise.all(transactionRequests).then(function () {

                    var parsedTransactions = [];

                    // For each transaction, make a parsed transaction which will be sent to the front end.
                    var transactionRequests = transactions.map(function (transaction) {

                        var parsedTransaction = {
                            // Change to be in line with SQL
                            Transaction_DateTime: moment(transaction.transaction.timestamp.toString(), "X"),
                            Transaction_Currency: "Units"
                        };

                        return new Promise(function (resolve) {
                            // For each record in the transaction
                            var recordRequests = transaction["mutation"]["records"].map(function (record) {

                                return new Promise(function(resolve) {
                                    const key = openchain.RecordKey.parse(record.key);

                                    if (key.path["parts"][0] === "stockchain") {
                                        parsedTransaction.Counterparty = "StockChain";
                                        resolve();
                                    }
                                    else {
                                        // If the record relates to the user, we want to calculate the difference in balance
                                        // between the previous version of the record and the value this transaction gave it.
                                        // ie. How much was sent/received from the Counterparty.
                                        if (key.path["parts"][1] === address.toString()) {
                                            client.getAccountRecord(key.path.toString(), key.name, record.version).then(function (previousRecord) {
                                                var newValue = record.value == null ? null : openchain.encoding.decodeInt64(record.value.data);
                                                parsedTransaction.Transaction_Amount = (newValue == null ? null : newValue.subtract(previousRecord.balance)).toInt();
                                                parsedTransaction.Balance = newValue;
                                                resolve();
                                            });
                                        }
                                        // If the record related to the Counterparty, just add the Counterparty to the parsed
                                        // transaction.
                                        else {
                                            parsedTransaction.Counterparty = key.path["parts"][1];
                                            resolve();
                                        }
                                    }
                                });
                            });

                            // Once both records retrieved and information added to the parsed transaction, push onto
                            // an array of all transactions.
                            Promise.all(recordRequests).then(function () {
                                parsedTransactions.push(parsedTransaction);
                                resolve();
                            });
                        });
                    });

                    Promise.all(transactionRequests).then(function() {

                        res.status(200).send(parsedTransactions);
                    });
                });
            });
        });
    });
});

apiRoutes.get("/getAccountBalance", restrict, function (req, res) {

    // Is username in DB -- would this ever happen?
    sqlConnection.query("SELECT * FROM account_auth WHERE Username = ?", req.session.user, function (err, rows) {
        if (err) {
            console.log(err);
            return res.status(500).send({reason: "DB query error"});
        }

        if (rows.length === 0) {
            return res.status(400).send({reason: "No such user " + req.session.user, errCode: "USER_ERR"});
        }

        // Stop hard coding this
        var client = new openchain.ApiClient("http://localhost:8080/");

        var userPrivateKey = bitcore.HDPrivateKey(rows[0]["Openchain_Key"]);
        var address = userPrivateKey.publicKey.toAddress();

        client.getAccountRecord(
            // Account path
            "/user/" + address + "/",
            // Asset path
            "/asset/unit/")
            .then(function (result) {

                sqlConnection.query("select Quote from nav_value order by Quote_Date desc limit 1", function (err, rows) {
                    if (err) {
                        console.error(err);
                        res.status(500).send({reason: "Problem fetching NAV from DB"});
                    }
                    else {
                        var currencyBalance = rows[0].Quote * result.balance/100;
                        res.status(200).send({
                            stock: {balance: result.balance.toString()},
                            // Placeholder
                            currency: {balance: currencyBalance.toString()}
                        });
                    }
                });
            });
    });
});

apiRoutes.get('/profile', restrict, function (req, res) {
    res.send({username: req.session.user});
});

// Apply the routes to the web server with the prefix /api
app.use('/api', apiRoutes);

// Homepage redirect
app.get('/*', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(8080);
console.log('StockChain is running on 8080');
