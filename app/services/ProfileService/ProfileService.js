(function() {
    'use strict';

    angular.module('api.ProfileService', [])
        .factory('ProfileService', function($http) {
            var ProfileService = {};

            ProfileService.getProfileDetails = function() {
                return $http.get('/user/profile').then(function(res) {
                    return res;
                });
            };

            return ProfileService;
        })
})();
