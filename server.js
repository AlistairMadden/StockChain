var express = require('express'),
    app = express(),
    sql = require('mysql'),
    morgan = require('morgan'),
    cookieParser = require('cookie-parser'),
    bodyParser = require('body-parser'),
    session = require('express-session'),
    path = require('path'),
    fs = require('fs'),
    bcrypt = require('bcrypt'),
    appDetails = JSON.parse(fs.readFileSync('./appDetails.json', 'utf-8'));

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

// connect to the DB
sqlConnection.connect(function(err){
    if(err){
        res.status(500).send({reason: "dbConnectionError"});
    }
});


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
    res.redirect('https://' + req.hostname + ':' + app.get('port_https') + req.url);
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

// TESTING ROUTE. Sort callback hell later. Delete later.
app.get('/setup', function (req, routeRes) {

    // simple user's password is password
    bcrypt.hash('password', saltRounds, function(err, hash) {

        // create a new simple user - make sure on sign up, username is transformed to lower case. Similar check on
        // login
        var user = {username: "alistair.madden@me.com", password: hash};

        // insert user (automatic sanitisation)
        sqlConnection.query("INSERT INTO accountAuth SET ?", user, function(err, dbRes) {
            if(err){
                routeRes.status(500).send({reason: "dbInsertionError"});
            }
            else {
                sqlConnection.query("SELECT account_id FROM accountAuth WHERE username = 'alistair.madden@me.com'", function (err, dbRes) {
                    if (err) {
                        routeRes.status(500).send({reason: "dbQueryError"});
                    }
                    else {
                        var userInfo = {account_id: dbRes[0]['account_id'], name: "Alistair Madden"};
                        sqlConnection.query("INSERT INTO accountDetails SET ?", userInfo, function (err) {
                            if (err) {
                                console.log(err);
                                routeRes.status(500).send({reason: "dbInsertionError"});
                            }
                            else {
                                routeRes.status(200).send();
                            }
                        });
                    }
                })
            }
        });
    });
});


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

    // Is username in DB?
    sqlConnection.query("SELECT * FROM accountAuth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            // DB error
            return callback(err, null, req, res);
        }
        else if (!(rows === undefined || rows.length === 0)) {
            // Hashed passwords match?
            return bcrypt.compare(req.body.password, rows[0].password, function (err, matchingHash) {
                if (err) {
                    return callback(err, null, req, res);
                }
                else if (matchingHash) {
                    return callback(null, req.body.username, req, res);
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
        res.status(err.statusCode).send();
    }
    else if (user) {
        req.session.regenerate(function () {
            console.log("Got here");
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
        var user = {username: req.body.username, password: hash};

        // insert user (automatic sanitisation)
        sqlConnection.query("INSERT INTO accountAuth SET ?", user, function(err, dbRes) {
            if(err){
                // handle case of duplicate email entry
                if(err.code === "ER_DUP_ENTRY") {
                    routeRes.status(409).send({reason: err.code});
                }
                else {
                    routeRes.status(500).send({reason: "dbInsertionError"});
                }
            }
            else {
                authenticate(req, routeRes, handleAuthenticationResponse);
            }
        });
    });
});

/**
 * Route used to make a transaction between user accounts
 *
 *
 */
apiRoutes.post("/makeTransaction", restrict, function (req, res) {

    // Nothing can be done if we don't have the data/it isn't correct
    if(!req.body.username) {
        return res.status(400).send({reason: "No recipient email given"});
    }
    else if (!req.body.amount) {
        return res.status(400).send({reason: "No amount specified"});
    }
    else if(!(typeof(req.body.amount) === "number")) {
        console.log(typeof(req.body.amount));
        return res.status(400).send({reason: "Amount given is not an integer value"});
    }
    else if(req.body.amount % 1 !== 0) {
        return res.status(400).send({reason: "Amount given is not an integer value"});
    }
    else if(!(typeof(req.body.username) === "string")) {
        return res.status(400).send({reason: "Username given is not a string"});
    }

    // Semantic problems
    if (req.body.username === req.session.user) {
        return res.status(400).send({reason: "Recipient's username is same as sender's username"});
    }

    // Check recipient is a valid user
    sqlConnection.query("SELECT username FROM accountauth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            console.log(err);
            return res.status(500).send({reason: "DB query error"});
        }

        if(rows.length === 0) {
            return res.status(400).send({reason: "No such user " + req.body.username, errCode: "INV_USER"});
        }

        // Look up current balance in session store (but for now, just look up direct from sql db)
        sqlConnection.query("CALL stockchain.getAccountStatement(?)", req.session.user, function(err, rows) {
            if (err) {
                console.error(err);
                return res.status(500).send({reason: "Error fetching account statement from DB"});
            }

            // Not enough money in account
            if (rows[0][0].balance < req.body.amount) {
                return res.status(400).send({reason: "Insufficient funds to make transfer of " + req.body.amount + " to " +
                req.body.username});
            }

            sqlConnection.query("CALL stockchain.makeTransaction(?,?,?)", [req.session.user, req.body.username, req.body.amount], function (err) {
                if (err) {
                    console.error(err);
                    return res.status(500).send({reason: "Error writing transaction to DB"});
                }
            });

            res.status(200).send();

        });
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
    sqlConnection.query("SELECT account_id FROM accountAuth WHERE username = ?", req.session.user,
        function (err, dbRes) {
            if (err) {
                res.status(500).send({reason: "dbQueryError"});
            }
            else {
                var accountId = dbRes[0].account_id;
                sqlConnection.query("SELECT Closing_Balance, Statement_Date FROM accountstatement WHERE account_id = ? ORDER BY Statement_Date DESC LIMIT 1", accountId,
                    function (err, dbRes) {
                        if (err) {
                            res.status(500).send({reason: "dbQueryError"});
                        }
                        else {
                            var lastStatementBalance = 0;
                            var lastStatementDate = new Date();
                            lastStatementDate.setDate(1);
                            lastStatementDate.setTime(0);

                            if (dbRes[0]) {
                                lastStatementBalance = dbRes[0]['Closing_Balance'];
                                lastStatementDate = dbRes[0]['Statement_Date'];
                            }


                            sqlConnection.query("SELECT Transaction_Amount, Transaction_ID FROM accounttransaction WHERE Transaction_DateTime >= ? AND Account_ID = ?", [lastStatementDate, accountId], function (err, dbRes) {
                                if (err) {
                                    res.status(500).send({reason: "dbQueryError"});
                                }
                                else {

                                    for (var i in dbRes) {
                                        if (dbRes[i]['Transaction_ID'] == 'C') {
                                            lastStatementBalance += dbRes[i]['Transaction_Amount'];
                                        }
                                        else if (dbRes[i]['Transaction_ID'] == 'D') {
                                            lastStatementBalance -= dbRes[i]['Transaction_Amount'];
                                        }
                                    }

                                    res.send({username: req.session.user, balance: lastStatementBalance});
                                }
                            });
                        }
                    })
            }
        });
});

app.use('/user', protectedRoutes);

app.get('/*', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(8080);
console.log('StockChain is running on 8080');
