/**
 * Created by Alistair on 16/11/2016.
 */

(function () {
    'use strict';

    angular.module('api.AuthService', [])
        .factory('AuthService', function ($http) {
            var authService = {};

            authService.login = function (credentials) {

                return $http.post('/api/login', credentials).then(function (res) {
                    return res;
                });
            };

            return authService;
        });
})();
