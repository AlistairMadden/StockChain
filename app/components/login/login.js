/**
 * Created by Alistair on 15/11/2016.
 */

(function() {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.login', [])
        .controller('loginController', function($scope, $rootScope, AUTH_EVENTS, AuthService) {
            $scope.credentials = {
                username: '',
                password: ''
            };
            /**
             * Login function
             *
             * Takes the credentials stored in the scope and attempts to authorise the user based on the credentials.
             * If successful, sets the current user and notifies the application of login success, otherwise notifies
             * the application of login failure.
             *
             * @param credentials
             */
            $scope.login = function (credentials) {
                AuthService.login(credentials).then(function success (user) {
                    $scope.setCurrentUser(user);
                    $rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
                }, function failure () {
                    $rootScope.$broadcast(AUTH_EVENTS.loginFailed);
                })
            }
        })
})();