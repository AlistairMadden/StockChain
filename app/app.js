(function() {
    'use strict';

    angular.module('stockChain', ['ui.router', 'components.home', 'api.transactions', 'components.transactions',
            'components.login', 'components.profile', 'components.signup', 'api.AuthService', 'api.ProfileService'
        ])
        .config(function($urlRouterProvider, $stateProvider, $locationProvider, AUTH_EVENTS, $httpProvider) {

            $httpProvider.defaults.withCredentials = true;

            $locationProvider.html5Mode(true);

            $stateProvider
                .state('home', {
                    url: '/',
                    templateUrl: 'components/home/home.html',
                    controller: 'homeController'
                })
                .state('transactions', {
                    url: '/transactions',
                    templateUrl: 'components/transactions/transactions.html',
                    controller: 'transactionsController',
                    resolve: {
                        user: function(AuthService) {
                            return AuthService.isAuthenticated();
                        }
                    }
                })
                .state('login', {
                    url: '/login',
                    templateUrl: 'components/login/login.html',
                    controller: 'loginController'
                })
                .state('signup', {
                    url: '/signup',
                    templateUrl: 'components/signup/signup.html',
                    controller: 'signupController'
                })
                .state('profile', {
                    url: '/profile',
                    templateUrl: 'components/profile/profile.html',
                    controller: 'profileController',
                    resolve: {
                        profileDetails: function(ProfileService, $state) {
                            return ProfileService.getProfileDetails().then(function(res) {
                                return res.data;
                            }).catch(function() {
                                console.log("ERROR");
                                $state.go('login');
                            });
                        }
                    }
                });

            $urlRouterProvider.otherwise('/404');
        })
        .constant('AUTH_EVENTS', {
            loginSuccess: 'auth-login-success',
            loginFailed: 'auth-login-failed',
            logoutSuccess: 'auth-logout-success',
            sessionTimeout: 'auth-session-timeout',
            notAuthenticated: 'auth-not-authenticated',
            notAuthorized: 'auth-not-authorized'
        })
        .controller('stockChain', function($scope) {

            $scope.loggedIn = false;
            $scope.currentUser = null;

            $scope.setCurrentUser = function(user) {
                $scope.currentUser = user;
            };
        });
})();
