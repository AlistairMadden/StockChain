/**
 * Created by Alistair on 16/11/2016.
 */

(function() {
    'use strict';

    angular.module('api.AuthService', [])
        .factory('AuthService', function ($http, Session, $state, $q, $timeout, $rootScope) {
            var authService = {};

            authService.login = function (credentials) {
                return $http
                    .post('api/login', credentials, {withCredentials: true})
                    .then(function (res) {
                        console.log(res.data);
                    }, function error () {
                        $state.go('login')
                    });
            };

            authService.isAuthenticated = function () {
                var deferred = $q.defer();

                $http.post('/api/loggedin').success(function(user){
                  if(user !== 401) {
                    deferred.resolve();
                  }
                  else {
                    deferred.reject();
                    $location.url('/login');
                  }
                });
                return deferred.promise;
            };

            return authService;
        })
        .service('Session', function () {
            this.create = function (sessionId, userId, userRole) {
                this.id = sessionId;
                this.userId = userId;
                this.userRole = userRole;
            };
            this.destroy = function () {
                this.id = null;
                this.userId = null;
                this.userRole = null;
            };
        });
})();
