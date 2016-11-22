/**
 * Created by Alistair on 15/11/2016.
 */

(function() {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.transactions', [])
        .controller('transactionsController', function($scope, transactions) {

            // Call all() and set to transactions
            $scope.transactions = transactions.all();
        })
})();