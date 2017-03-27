(function () {
    'use strict';

    // Controller for the account overview.
    angular.module('components.purchaseUnits', [])
        .controller('purchaseUnitsController', function ($scope, TransactionService) {
            $scope.requestFinancialAid = function () {
                TransactionService.addFundTransation();
            }
        });
})();
