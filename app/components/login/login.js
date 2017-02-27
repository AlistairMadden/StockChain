/**
 * Created by Alistair on 15/11/2016.
 */

(function () {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.login', [])
        .controller('loginController', function ($scope, $rootScope, AuthService, $state) {

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
                if ($scope.credentials.username && $scope.credentials.password) {
                    AuthService.login(credentials).then(function () {
                        $state.go('account.overview');
                    }).catch(function (res) {
                        if(res.status == 401) {
                            $scope.unrecognisedCredentials = true;
                        }
                    });
                }
            }
        })
})();
