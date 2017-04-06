(function () {
    'use strict';

    // Controller for the account overview.
    angular.module('components.transactions', [])
        .controller('transactionsController', function ($scope, accountTransactions) {

            accountTransactions.forEach(function (transaction) {
                transaction["Transaction_DateTime"] = moment(transaction["Transaction_DateTime"]).format("Do MMM YYYY");
                if(transaction["Transaction_Code"] == "D") {
                    transaction["Transaction_Amount"] = -transaction["Transaction_Amount"]
                }
            });

            $scope.transactions = accountTransactions;
        });
})();
