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
    jwt = require('jsonwebtoken'),
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
                        sqlConnection.query("INSERT INTO accountInfo SET ?", userInfo, function (err) {
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

    sqlConnection.query("SELECT * FROM accountAuth WHERE username = ?", req.body.username, function (err, rows) {
        if (err) {
            console.log(req.body.username);
            console.log(err);
            res.status(500).send();
        }
        else if (!(rows === undefined || rows.length === 0)) {

            bcrypt.compare(req.body.password, rows[0].password, function (err, matchingHash) {

                if (matchingHash !== true) {
                    res.status(401).send({reason: "passwordError"});
                }
                else {

                    // If user is found and password is right create a token
                    var token = jwt.sign(req.body.username, appDetails.secret);

                    // Store jwt in a cookie
                    res.cookie('token', token, {
                        httpOnly: true,
                        secure: true
                    });

                    res.cookie('XSRF-TOKEN', appDetails.secret);

                    res.status(200).send({message: 'Successfully logged in.'});
                }
            });
        }
        else {
            res.status(401).send({reason: "usernameError"});
        }
    });
});

// log out route
apiRoutes.post('/logout', function(req, res) {

});

apiRoutes.post('/signup', function (routeRes, req) {

    bcrypt.hash(req.body.password, saltRounds, function(err, hash) {

        // create a new simple user - make sure on sign up, username is transformed to lower case. Similar check on
        // login
        var user = {username: req.body.username, password: hash};

        // insert user (automatic sanitisation)
        sqlConnection.query("INSERT INTO accountAuth SET ?", user, function(err, dbRes) {
            if(err){
                routeRes.status(500).send({reason: "dbInsertionError"});
            }
            else {
                sqlConnection.query("SELECT account_id FROM accountAuth WHERE username = 'alistair.madden@me.com'",
                    function (err, dbRes) {

                    if (err) {
                        routeRes.status(500).send({reason: "dbQueryError"});
                    }
                    else {
                        var userInfo = {account_id: dbRes[0]['account_id'], name: req.body.name};
                        sqlConnection.query("INSERT INTO accountInfo SET ?", userInfo, function (err) {
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

// apply the routes to our application with the prefix /api
app.use('/api', apiRoutes);

/*
  All other routes
 */

var protectedRoutes = express.Router();

protectedRoutes.get('/profile', function(req, res) {
  console.log(req.cookies);
  if (req.cookies['XSRF-TOKEN']) {
      if (req.cookies['XSRF-TOKEN'] === appDetails.secret) {
          if (req.cookies['token']) {
              jwt.verify(req.cookies['token'], appDetails.secret, function(err, decoded) {
                  if (err) {
                      res.status(500).send({message: err});
                  } else {
                    console.log('JWT Verified');
                    res.send({decoded: decoded})
                  }
              });
          }
          else {
            res.status(401).send({message: "no session cookie"});
          }
      }
      else {
        res.status(401).send({message: "XSRF-TOKEN does not match"})
      }
  } else {
      res.status(401).send();
  }
});

app.use('/user', protectedRoutes);

app.get('/*', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(8080);
console.log('StockChain is running on 8080');
