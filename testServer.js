/**
 * Created by Alistair on 15/03/2017.
 */

var sql = require('mysql'),
    fs = require('fs'),
    appDetails = JSON.parse(fs.readFileSync('./appDetails.json', 'utf-8')),
    moment = require('moment'),
    bcrypt = require('bcrypt');

var sqlConnection = sql.createConnection({
    host: appDetails.sqlDbUrl,
    user: appDetails.sqlDbUser,
    password: appDetails.sqlDbPassword,
    database: appDetails.sqlDbName
});

sqlConnection.connect(function(err) {
    if (err) {
        console.error(err);
    }
    else {
        updateNav(secondUpdateNav);
    }
});

function updateNav(callback) {
    sqlConnection.query("call update_nav_value()", function(err) {
        if(err) {
            console.error(err);
        }
        else {
            sqlConnection.query("select * from nav_value", function (err, rows) {
                if (err) {
                    console.error(err);
                }
                else {
                    if(rows.length === 1) {
                        if (rows[0]["Quote"] === 1) {

                            // set up expected datetime
                            var quoteDate;
                            if(moment().isBefore(moment().minute(40).hour(16))) {
                                quoteDate = moment().subtract(1, "days").hour(0).minute(0).second(0).millisecond(0);
                            }
                            else {
                                quoteDate = moment().hour(0).minute(0).second(0).millisecond(0);
                            }

                            if (moment(rows[0]["Quote_Date"]).isSame(quoteDate)) {
                                console.log("OK - updateNav");
                                callback(signInNoAccount);
                            }
                            else {
                                console.error("Fail - updateNav\nReason: Expected Quote_Date " +
                                    quoteDate.format() + " but got " + moment(rows[0]["Quote_Date"]).format());
                            }

                        }
                        else {
                            console.error("Fail - updateNav\nReason: Quote does not equal 1");
                        }
                    }
                    else {
                        console.error("Fail - updateNav\nReason: More than one row returned");
                    }
                }
            })
        }
    });
}

function secondUpdateNav(callback) {
    sqlConnection.query("call update_nav_value()", function(err) {
        if (err.code = "ER_DUP_ENTRY") {
            console.log("OK - secondUpdateNav");
            callback(userSignUp);
        }
        else {
            console.error("Fail - secondUpdateNav\nReason: Did not throw duplicate error entry");
        }
    })
}

function signInNoAccount(callback) {
    var req = {body: {}};
    req.body.username = "alistair.john.madden@gmail.com";
    req.body.password = "password";

    sqlConnection.query("SELECT * FROM account_auth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            console.error(err);
            console.error("Fail - signInNoAccount\nReason: DB error");
        }
        else if (rows === undefined || rows.length === 0) {
            console.log("OK - signInNoAccount");
            callback(signIn);
        }
        else {
            console.error("Fail - signInNoAccount\nReason: Account returned when one shouldn't be?! What the hell?");
        }
    })
}

function userSignUp(callback) {

    var req = {body: {}};
    req.body.username = "alistair.john.madden@gmail.com";
    req.body.password = "password";

    bcrypt.hash(req.body.password, 10, function(err, hash) {

        // create a new simple user - make sure on sign up, username is transformed to lower case. Similar check on
        // login
        var user = {Username: req.body.username.toLocaleLowerCase(), Password_Hash: hash};

        // insert user (automatic sanitisation)
        sqlConnection.query("INSERT INTO account_auth SET ?", user, function (err) {
            if (err) {
                // handle case of duplicate email entry
                if (err.code === "ER_DUP_ENTRY") {
                    console.error("Fail - userSignUp\nReason: Duplicate entry");
                }
                else {
                    console.error("Fail - userSignUp\nReason: Database insertion error");
                }
            }
            else {
                sqlConnection.query("SELECT * from account_auth WHERE Username = ?", req.body.username.toLocaleLowerCase(), function (err, rows) {
                    if (err) {
                        console.error("Fail - userSignUp\nReason: Error fetching from database")
                    }
                    else if(rows.length === 1) {
                        if(rows[0].Username === req.body.username.toLocaleLowerCase()) {
                            bcrypt.compare(req.body.password, rows[0]["Password_Hash"], function (err, matchingHash) {
                                if (err) {
                                    console.error("Fail - userSignUp\nReason: bcrypt internal error");
                                }
                                else if (matchingHash) {
                                    console.log("OK - userSignUp");
                                    callback(everythingIsOK);
                                }
                                else {
                                    // no error and no matching hash = incorrect hash
                                    console.error("Fail - userSignUp\nReason: Incorrect hash");
                                }
                            })
                        }
                        else {
                            console.error("Fail - userSignUp\nReason: Username does not match input")
                        }
                    }
                    else {
                        console.error("Fail - userSignUp\nReason: More or less than 1 row returned. Wat?")
                    }
                });
            }
        });
    });
}

function signIn(callback) {
    var req = {body: {}};
    req.body.username = "alistair.john.madden@gmail.com";
    req.body.password = "password";

    // Is username in DB?
    sqlConnection.query("SELECT * FROM account_auth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            // DB error
            console.error("Fail - signIn\nReason: Database error")
        }
        else if (!(rows === undefined || rows.length === 0)) {
            // Hashed passwords match?
            return bcrypt.compare(req.body.password, rows[0]["Password_Hash"], function (err, matchingHash) {
                if (err) {
                    console.error("Fail - signIn\nReason: bcrypt error")
                }
                else if (matchingHash) {
                    console.log("OK - signIn");
                    callback();
                }
                else {
                    console.error("Fail - signIn\nReason: Invalid password for username " + req.body.username);
                }
            })
        }
        else {
            console.error("Fail - signIn\nReason: No such user " + req.body.username);
        }
    })
}

function everythingIsOK() {
    console.log("All tests passed!");
    // required for the process to terminate
    sqlConnection.destroy();
}
