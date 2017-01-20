/**
 * Created by Alistair on 28/12/2016.
 */

(function () {
    'use strict';

    var compareTo = function() {
        return {
            require: "ngModel",
            scope: {
                password: "=compareTo"
            },
            link: function(scope, element, attributes, ngModel) {

                ngModel.$validators.compareTo = function(confirmPassword) {
                    scope.unmatchedPasseords = confirmPassword == scope.password;
                    return confirmPassword == scope.password;
                };

                scope.$watch("password", function() {
                    ngModel.$validate();
                });
            }
        };
    };
    
    angular.module('components.signup', [])
        .controller('signupController', function ($scope, $rootScope, AuthService, $state) {

            $scope.credentials = {
                username: '',
                password: '',
                confirmPassword: ''
            };

            $scope.incorrectSubmission = false;
            $scope.umatchedPasswords = false;

            /**
             * Sign Up function
             *
             *
             *
             * @param credentials
             */
            $scope.signup = function (credentials) {
                if ($scope.credentials.username && $scope.credentials.password && ($scope.credentials.password ===
                    $scope.credentials.confirmPassword)) {
                    AuthService.signup(credentials).then(function () {
                        console.log("signedup");
                        $state.go('profile');
                    }).catch(function () {
                        console.error("Error creating account");
                    });
                }
                else {
                    $scope.incorrectSubmission = true;
                }
            }
        })
        .directive("compareTo", compareTo)
})();