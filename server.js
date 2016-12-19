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


// TESTING ROUTE
app.get('/setup', function(req, res) {

    // wipe collection
    Users.remove(function(err, removed) {
        console.log('Removed ' + removed.n + ' documents.')
    });

    bcrypt.hash('password', saltRounds, function(err, hash) {
        // create a sample user
        var ali = new Users({
            username: 'Alistair.Madden@me.com',
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
// apiRoutes.post('/loggedin', function(req, res) {
//     res.sendStatus(isAuthenticated(req));
// });

// function isAuthenticated(req) {
//     if (req.cookies['X-XSRF-TOKEN']) {
//         if (req.cookies['X-XSRF-TOKEN'] === appDetails.secret) {
//             if (req.cookies['session']) {
//               jwt.verify(req.cookies['session'], app.get(appDetails.secret), function(err, decoded) {
//       if (err) {
//         return res.json({ success: false, message: 'Failed to authenticate token.' });
//       } else {
//         // if everything is good, save to request for use in other routes
//         req.decoded = decoded;
//         next();
//       }
//     });
//             }
//         }
//     } else {
//         return 401;
//     }
// }

// Sign up route
/*app.post('/api/signup', function(req, res) {
    if(req.cookies.token)
});*/

// log in route
apiRoutes.post('/login', function(req, res) {

    // find the user
    Users.findOne({
        username: req.body.username
    }, function(err, user) {

        if (err) throw err;

        if (!user) {
            res.status(401).send({
                reason: 'usernameError'
            });
        } else if (user) {

            bcrypt.compare(req.body.password, user.hash, function(err, result) {
                if (result !== true) {
                    res.status(401).send({
                        reason: 'passwordError'
                    });
                } else {

                    // If user is found and password is right create a token
                    var token = jwt.sign(user, appDetails.secret);

                    // Store jwt in a cookie
                    res.cookie('token', token, {
                        httpOnly: true,
                        secure: true
                    });

                    res.cookie('XSRF-TOKEN', appDetails.secret);

                    res.status(200).send({
                        message: 'Successfully logged in.'
                    })
                }

            });
        }
    });
});

// log out route
apiRoutes.post('/logout', function(req, res) {

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
                    console.log('JWT Verified')
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
