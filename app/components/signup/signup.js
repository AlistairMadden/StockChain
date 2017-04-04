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

                // Extend validators with a password check
                ngModel.$validators.compareTo = function(confirmPassword) {
                    return confirmPassword == scope.password;
                };

                // Every time password is altered, reevaluate the validation
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
                        $state.go('account.overview');
                    }).catch(function (err) {
                        if (err.status = 409) {
                            $scope.error409 = true;
                        }
                        else {
                            console.error(err);
                        }
                    });
                }
                else {
                    $scope.incorrectSubmission = true;
                }
            }
        })
        .directive("compareTo", compareTo)
})();