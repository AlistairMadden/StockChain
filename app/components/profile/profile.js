(function () {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.profile', [])
        .controller('profileController', function ($scope, profileDetails) {
            $scope.profileDetails = profileDetails;
        })
})();
