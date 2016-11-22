var express = require('express'),
    app = express(),
    mongoose = require('mongoose'),
    morgan = require('morgan'),
    cookieParser = require('cookie-parser'),
    bodyParser = require('body-parser'),
    session = require('express-session'),
    path = require('path'),
    fs = require('fs'),
    bcyrpt = require('bcrypt'),
    jwt = require('jsonwebtoken'),
    appDetails = JSON.parse(fs.readFileSync('./appDetails.json', 'utf-8'));

const saltRounds = 10;

/*
  DB Setup
*/
mongoose.connect(appDetails.dbURL);
var localUserSchema = new mongoose.Schema({
    username: String,
    hash: String
});

var Users = mongoose.model('userauths', localUserSchema);


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

// Use body parser so information can be grabbed from POST and/or URL parameters
app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(bodyParser.json());

// Use morgan to log requests to the console
app.use(morgan('dev'));

// Use cookieParser for handling of cookies
app.use(cookieParser());

// TESTING ROUTE
app.get('/setup', function(req, res) {

    // create a sample user
    var ali = new Users({
        name: 'Alistair Madden',
        password: 'password'
    });

    // save the sample user
    ali.save(function(err) {
        if (err) throw err;

        console.log('User saved successfully');
        res.json({
            success: true
        });
    });
});


/*
  API routes
 */

var apiRoutes = express.Router();

// log in check route
apiRoutes.post('/loggedin', function(req, res) {
    res.sendStatus(isAuthenticated(req));
});

function isAuthenticated(req) {
    if (req.cookies['X-XSRF-TOKEN']) {
        if (req.cookies['X-XSRF-TOKEN'] === appDetails.secret) {
            if (req.cookies['session']) {
            }
        }
    } else {
        return 401;
    }
}

// Sign up route
/*app.post('/api/signup', function(req, res) {
    if(req.cookies.token)
});*/

// log in route
app.post('/api/login', function(req, res) {
    // if (req.cookies) {
    //     console.log(req.cookies);
    //     res.send('cookie already created');
    // } else {
        // find the user
        Users.findOne({
            name: req.body.name
        }, function(err, user) {

            console.log(user.password);

            if (err) throw err;

            if (!user) {
                res.json({
                    success: false,
                    message: 'Authentication failed. User not found.'
                });
            } else if (user) {

                // check if password matches
                if (user.password != req.body.password) {
                    res.json({
                        success: false,
                        message: 'Authentication failed. Wrong password.'
                    });
                } else {

                    // if user is found and password is right
                    // create a token
                    var token = jwt.sign(user, appDetails.secret);

                    res.cookie('token', token, {
                        httpOnly: true,
                        secure: true
                    });

                    res.cookie('X-XSRF-TOKEN', appDetails.secret);

                    // return the information including token as JSON
                    res.json({
                        success: true,
                        message: 'Enjoy your token!',
                        token: token
                    });
                }

            }

        });
    // }
});

// log out route
app.post('/api/logout', function(req, res) {
    req.logOut();
    res.send(200);
});


/*
  All other routes
 */

app.get('/*', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(8080);
console.log('StockChain is running on 8080');
