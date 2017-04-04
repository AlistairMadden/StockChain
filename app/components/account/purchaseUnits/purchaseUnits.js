(function () {
    'use strict';

    // Controller for purchaseUnits state
    angular.module('components.purchaseUnits', [])
        .controller('purchaseUnitsController', function ($scope, TransactionService) {
            $scope.requestFinancialAid = function () {
                TransactionService.addFundTransation();
            }
        });
})();
