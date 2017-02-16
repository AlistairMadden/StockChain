(function () {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.overview', [])
        .controller('overviewController', function ($scope, profileDetails, TransactionService, accountBalance) {
            $scope.profileDetails = profileDetails;
            $scope.currencyBalance = Math.trunc(accountBalance.currency.balance * 100)/ 100;
            $scope.stockBalance = Math.trunc(accountBalance.stock.balance * 100)/ 100;

            $scope.transactionDetails = {};

            $scope.submitMessages = {};

            $scope.makeTransaction = function (transactionDetails) {
                if (transactionDetails) {
                    if (!transactionDetails.username) {
                        $scope.submitMessages.noRecipient = true;
                    }
                    if (profileDetails.username === transactionDetails.username) {
                        $scope.submitMessages.selfEmail = true;
                    }
                    else {
                        if ($scope.currency == "GBP") {
                            if ($scope.currencyBalance < transactionDetails.amount) {
                                $scope.submitMessages.insufficientFunds = true;
                            }
                            else {
                                TransactionService.makeTransactionCurrency(transactionDetails, $scope.currency).then(function (transactionServiceRes) {
                                    if (transactionServiceRes.status === 200) {
                                        $scope.currencyBalance = Math.trunc(transactionServiceRes.data.currency.balance * 100)/ 100;
                                        $scope.stockBalance = Math.trunc(transactionServiceRes.data.stock.balance * 100)/ 100;
                                        $scope.submitMessages.transactionSuccess = true;
                                    }
                                }).catch(function (err) {
                                    if (err.data.errCode === "INV_USER") {
                                        $scope.submitMessages.invalidRecipient = true;
                                    }
                                    else {
                                        console.log(err);
                                    }
                                });
                            }
                        }
                        else {
                            if ($scope.stockBalance < transactionDetails.amount) {
                                $scope.submitMessages.insufficientFunds = true;
                            }
                            else {
                                TransactionService.makeTransaction(transactionDetails).then(function (transactionServiceRes) {
                                    if (transactionServiceRes.status === 200) {
                                        $scope.currencyBalance = Math.trunc(transactionServiceRes.data.currency.balance * 100)/ 100;
                                        $scope.stockBalance = Math.trunc(transactionServiceRes.data.stock.balance * 100)/ 100;
                                        $scope.submitMessages.transactionSuccess = true;
                                    }
                                }).catch(function (err) {
                                    if (err.data.errCode === "INV_USER") {
                                        $scope.submitMessages.invalidRecipient = true;
                                    }
                                });
                            }
                        }
                    }
                }
                else {
                    $scope.invalidTransactionDetails = true;
                }
            }
        })
})();
