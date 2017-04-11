var express = require('express'),
    app = express(),
    sql = require('mysql'),
    morgan = require('morgan'),
    cookieParser = require('cookie-parser'),
    bodyParser = require('body-parser'),
    session = require('express-session'),
    path = require('path'),
    fs = require('fs'),
    appDetails = JSON.parse(fs.readFileSync('./appDetailsAWS.json', 'utf-8')),
    bcrypt = require('bcrypt'),
    schedule = require("node-schedule");

const saltRounds = 10;

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

app.all('*', function(req, res, next) {
    if (req.secure) {
        return next();
    }
    res.redirect('https://' + req.hostname + req.url);
});

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
    cookie: {secure: true, sameSite: true} // https
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

// log out route
apiRoutes.get('/logout', function(req, res) {
    // destroy the user's session to log them out
    // will be re-created next request
    req.session.destroy(function(){
        res.status(200).send();
    });
});

apiRoutes.post('/signup', function (req, routeRes) {

    bcrypt.hash(req.body.password, saltRounds, function(err, hash) {

        // create a new simple user - make sure on sign up, username is transformed to lower case. Similar check on
        // login
        var user = {Username: req.body.username.toLocaleLowerCase(), Password_Hash: hash};

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
                // also login
                authenticate(req, routeRes, handleAuthenticationResponse);
            }
        });
    });
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
    sqlConnection.query("SELECT username FROM account_auth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            console.log(err);
            return res.status(500).send({reason: "DB query error"});
        }

        if(rows.length === 0) {
            return res.status(400).send({reason: "No such user " + req.body.username, errCode: "USER_ERR"});
        }

        if(req.body.currency == "GBP") {
            // Look up current balance in session store (but for now, just look up direct from sql db)
            sqlConnection.query("CALL get_account_balance(?)", req.session.user, function(err, rows) {
                if (err) {
                    console.error(err);
                    return res.status(500).send({reason: "Error fetching account statement from DB"});
                }

                // Not enough money in account
                if (rows[0][0].balance < req.body.amount) {
                    return res.status(400).send({
                        reason: "Insufficient funds to make transfer of " + req.body.amount + " to " +
                        req.body.username, errCode: "AMT_ERR"
                    });
                }

                makeTransaction();

            });
        }


        else if(req.body.currency == "Units") {
            // Look up current balance in session store (but for now, just look up direct from sql db)
            sqlConnection.query("CALL get_account_stock_balance(?)", req.session.user, function(err, rows) {
                if (err) {
                    console.error(err);
                    return res.status(500).send({reason: "Error fetching account statement from DB"});
                }

                // Not enough money in account
                if (rows[0][0].balance < req.body.amount) {
                    return res.status(400).send({reason: "Insufficient funds to make transfer of " + req.body.amount + " to " +
                    req.body.username, errCode: "AMT_ERR"});
                }

                makeTransaction();
            });
        }

        function makeTransaction() {
            sqlConnection.query("CALL make_transaction(?,?,?,?)", [req.session.user, req.body.username, req.body.amount, req.body.currency], function (err) {
                if (err) {
                    console.error(err);
                    return res.status(500).send({reason: "Error writing transaction to DB"});
                }

                sqlConnection.query("call get_account_balance(?)", req.session.user, function (err, dbRes) {
                    if (err) {
                        console.error(err);
                        return res.status(500).send({reason: "Error fetching updated currency balance"});
                    }

                    var currency = dbRes[0][0];

                    sqlConnection.query("call get_account_stock_balance(?)", req.session.user, function (err, dbRes) {
                        if (err) {
                            console.error(err);
                            return res.status(500).send({reason: "Error fetching updated stock balance"});
                        }

                        res.status(200).send({"currency": currency, "stock": dbRes[0][0]});
                    });
                });
            });
        }
    });
});

/**
 * Gets the logged in user's transactions
 */
apiRoutes.get("/getAccountTransactions", restrict, function (req, res) {
    sqlConnection.query("call get_account_transactions(?)", req.session.user, function (err, dbResponse) {
        if (err) {
            console.error(err);
            return res.status(500).send({reason: "Error fetching transactions from DB"});
        }

        res.status(200).send(dbResponse[0]);
    })
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

        sqlConnection.query("call get_account_balance(?)", req.session.user, function (err, dbResponse) {
            if (err) {
                console.error(err);
                return res.status(500).send({reason: "Error fetching transactions from DB"});
            }

            var preferredCurrencyBalance = dbResponse[0][0];

            sqlConnection.query("call get_account_stock_balance(?)", req.session.user, function (err, dbResponse) {
                if (err) {
                    console.error(err);
                    return res.status(500).send({reason: "Error fetching transactions from DB"});
                }

                res.status(200).send({"currency": preferredCurrencyBalance, "stock": dbResponse[0][0]});
            })
        })
    });
});

// apply the routes to the web server with the prefix /api
app.use('/api', apiRoutes);

/*
  All other routes
 */

var protectedRoutes = express.Router();

// I need help from callback hell
protectedRoutes.get('/profile', restrict, function (req, res) {
    res.send({username: req.session.user});
});

app.use('/user', protectedRoutes);

app.get('/*', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(8080);

console.log('StockChain is running on 8080');
