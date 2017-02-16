(function () {
    'use strict';

    angular.module('stockChain', ['ui.router', 'components.home', 'components.login',
        'components.signup', 'components.overview', 'components.account', 'api.AuthService', 'api.ProfileService',
        'api.TransactionService'
    ])
        .config(function ($urlRouterProvider, $stateProvider, $locationProvider, $httpProvider) {

            $httpProvider.defaults.withCredentials = true;

            $locationProvider.html5Mode(true);

            $stateProvider
                .state('website', {
                    abstract: true,
                    templateUrl: 'components/home/home.html',
                    controller: 'homeController'
                })
                .state('website.welcome', {
                    url: '/',
                    templateUrl: 'components/home/welcome.html'
                })
                .state('website.login', {
                    url: '/login',
                    templateUrl: 'components/login/login.html',
                    controller: 'loginController'
                })
                .state('website.signup', {
                    url: '/signup',
                    templateUrl: 'components/signup/signup.html',
                    controller: 'signupController'
                })
                .state('account', {
                    abstract: true,
                    url: '/account',
                    templateUrl: 'components/account/account.html',
                    controller: 'accountController'
                })
                .state('account.overview', {
                    url: '/overview',
                    templateUrl: 'components/account/overview.html',
                    controller: 'overviewController',
                    resolve: {
                        profileDetails: function (ProfileService, $state) {
                            return ProfileService.getProfileDetails().then(function (res) {
                                return res.data;
                            }).catch(function () {
                                $state.go('website.login');
                            });
                        },
                        accountBalance: function (ProfileService) {
                            return ProfileService.getAccountBalance().then(function (res) {
                                return res.data;
                            })
                        }
                    }
                })
                .state('account.transactions', {
                    url: '/transactions',
                    templateUrl: 'components/account/transactions.html',
                    controller: 'transactionsController',
                    resolve: {
                        profileDetails: function (ProfileService, $state) {
                            return ProfileService.getProfileDetails().then(function (res) {
                                return res.data;
                            }).catch(function () {
                                $state.go('website.login');
                            });
                        }
                    }
                })
                .state('account.logout', {
                    controller: function ($scope, $state, AuthService) {
                        AuthService.logout().then(function () {
                            $state.go('website.welcome');
                        });
                    }
                });

            $urlRouterProvider.otherwise('/404');
        })
        .controller('stockChain', function ($scope) {

        });
})();
