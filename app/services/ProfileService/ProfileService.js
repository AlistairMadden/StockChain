(function() {
    'use strict';

    angular.module('ProfileService', [])
        .factory('ProfileService', function($http, $state, $q, $timeout, $rootScope) {
            var ProfileService = {};

            ProfileService.getProfileDetails = function() {
                return $http.get('/user/profile').then(function(res) {
                    console.log('here');
                    return res;
                });
            };

            return ProfileService;
        })
})();
