(function () {
    'use strict';

    angular.module('stockChain', ['ui.router', 'components.home', 'components.login', 'components.profile',
        'components.signup', 'api.AuthService', 'api.ProfileService'
    ])
        .config(function ($urlRouterProvider, $stateProvider, $locationProvider, $httpProvider) {

            $httpProvider.defaults.withCredentials = true;

            $locationProvider.html5Mode(true);

            $stateProvider
                .state('home', {
                    url: '/',
                    templateUrl: 'components/home/home.html',
                    controller: 'homeController'
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
                                $state.go('login');
                            });
                        }
                    }
                });

            $urlRouterProvider.otherwise('/404');
        })
        .controller('stockChain', function($scope) {

            $scope.loggedIn = false;
            $scope.currentUser = null;

        });
})();
