var express = require('express'),
    app = express(),
    mongoose = require('mongoose'),
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

    // wipe collection
    Users.remove(function(err, removed) {
        console.log('Removed ' + removed.n + ' documents.')
    });

    bcrypt.hash('password', saltRounds, function(err, hash) {
        // create a sample user
        var ali = new Users({
            username: 'Alistair Madden',
            hash: hash
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
            if (req.cookies['session']) {}
        }
    } else {
        return 401;
    }
}

// route to return all users (GET http://localhost:8080/api/users)
apiRoutes.get('/users', function(req, res) {
    Users.find({}, function(err, users) {
        res.json(users);
    });
});

// Sign up route
/*app.post('/api/signup', function(req, res) {
    if(req.cookies.token)
});*/

// log in route
apiRoutes.post('/login', function(req, res) {

    console.log(req.body.username);

    // find the user
    Users.findOne({
        username: req.body.username
    }, function(err, user) {

        if (err) throw err;

        if (!user) {
            res.json({
                success: false,
                message: 'Authentication failed. User not found.'
            });
        } else if (user) {

            bcrypt.compare(req.body.password, user.hash, function(err, result) {
                if (result !== true) {
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
            });
        }

    });
    // }
});

// log out route
apiRoutes.post('/api/logout', function(req, res) {
    req.logOut();
    res.send(200);
});

// apply the routes to our application with the prefix /api
app.use('/api', apiRoutes);

/*
  All other routes
 */

app.get('/*', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(8080);
console.log('StockChain is running on 8080');
