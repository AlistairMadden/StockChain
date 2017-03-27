(function() {
    'use strict';

    angular.module('api.ProfileService', [])
        .factory('ProfileService', function($http) {
            var ProfileService = {};

            ProfileService.getProfileDetails = function() {
                return $http.get('/api/profile').then(function(res) {
                    return res;
                });
            };

            ProfileService.getAccountBalance = function () {
                return $http.get('/api/getAccountBalance').then(function (res) {
                    return res;
                })
            };

            return ProfileService;
        })
})();
