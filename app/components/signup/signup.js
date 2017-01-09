/**
 * Created by Alistair on 28/12/2016.
 */

(function () {
    'use strict';
    
    angular.module('components.signup', [])
        .controller('signupController', function ($scope, $rootScope, AuthService, $state) {

            $scope.credentials = {
                username: '',
                password: ''
            };

            $scope.name = "";

            /**
             * Sign Up function
             *
             * Takes the credentials stored in the scope and attempts to authorise the user based on the credentials.
             * If successful, sets the current user and notifies the application of login success, otherwise notifies
             * the application of login failure.
             *
             * @param credentials
             */
            $scope.signup = function (credentials) {
                if ($scope.credentials.username && $scope.credentials.password && $scope.name) {
                    AuthService.login(credentials).then(function (res) {
                        $state.go('profile');
                    }).catch(function (res) {
                        console.error("Error creating account");
                    });
                }
            }
        })
})();