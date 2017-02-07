(function () {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.overview', [])
        .controller('overviewController', function ($scope, profileDetails, TransactionService) {
            $scope.profileDetails = profileDetails;
            $scope.currencyEquivalent = (profileDetails.balance * profileDetails.FTSEQuote / 1000).toFixed(2);

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
                            if ($scope.currencyEquivalent < transactionDetails.amount) {
                                $scope.submitMessages.insufficientFunds = true;
                            }
                            else {
                                TransactionService.makeTransactionCurrency(transactionDetails, $scope.currency).then(function (transactionServiceRes) {
                                    if (transactionServiceRes.status === 200) {
                                        $scope.submitMessages.transactionSuccess = true;
                                        $scope.profileDetails.balance = transactionServiceRes.data.balance;
                                        $scope.currencyEquivalent = (transactionServiceRes.data.balance * profileDetails.FTSEQuote / 1000).toFixed(2);
                                    }
                                }).catch(function (err) {
                                    if (err.data.errCode === "INV_USER") {
                                        $scope.submitMessages.invalidRecipient = true;
                                    }
                                });
                            }
                        }
                        else {
                            TransactionService.makeTransaction(transactionDetails).then(function (transactionServiceRes) {
                                if (transactionServiceRes.status === 200) {
                                    $scope.submitMessages.transactionSuccess = true;
                                    $scope.profileDetails.balance = transactionServiceRes.data.balance;
                                    $scope.currencyEquivalent = (transactionServiceRes.data.balance * profileDetails.FTSEQuote / 1000).toFixed(2);
                                }
                            }).catch(function (err) {
                                if (err.data.errCode === "INV_USER") {
                                    $scope.submitMessages.invalidRecipient = true;
                                }
                            });
                        }
                    }
                }
                else {
                    $scope.invalidTransactionDetails = true;
                }
            }
        })
})();
