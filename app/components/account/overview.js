(function () {
    'use strict';

    // Controller for the account overview.
    angular.module('components.overview', [])
        .controller('overviewController', function ($scope, profileDetails, TransactionService, accountBalance) {
            $scope.profileDetails = profileDetails;
            $scope.currencyBalance = accountBalance.currency.balance;
            $scope.stockBalance = accountBalance.stock.balance;

            $scope.transactionDetails = {};

            $scope.submitMessages = {};

            $scope.makeTransaction = function (transactionDetails) {

                // A part of the transaction form was completed incorrectly
                if (!transactionDetails.username) {
                    $scope.usernameError = true;
                    $scope.usernameErrorMessage = "No user specified."
                }
                if (!transactionDetails.amount) {
                    $scope.amountError = true;
                    $scope.amountErrorMessage = "No amount specified."
                }
                if (transactionDetails.username && transactionDetails.amount) {
                    transactionDetails.username = transactionDetails.username.toLocaleLowerCase();
                    if (profileDetails.username === transactionDetails.username) {
                        $scope.submitMessages.noRecipient = true;
                    }
                    else {
                        if ($scope.currency == "GBP") {
                            TransactionService.makeTransactionCurrency(transactionDetails, $scope.currency)
                                .then(function (transactionServiceRes) {
                                    if (transactionServiceRes.status === 200) {
                                        $scope.currencyBalance = Math
                                                .trunc(transactionServiceRes.data.currency.balance * 100) / 100;
                                        $scope.stockBalance = Math
                                                .trunc(transactionServiceRes.data.stock.balance * 100) / 100;
                                        $scope.counterparty = transactionDetails.username;
                                        $scope.submitMessages.transactionSuccess = true;
                                    }
                                }).catch(function (err) {

                                    console.error(err);

                                if (err.data.errCode === "AMT_ERR") {
                                    $scope.amountError = true;
                                    $scope.amountErrorMessage = err.data.reason;
                                }
                                else if (err.data.errCode === "USER_ERR") {
                                    $scope.usernameError = true;
                                    $scope.usernameErrorMessage = err.data.reason;
                                }
                                else {
                                    console.log(err);
                                }
                            });
                        }
                        else {
                            TransactionService.makeTransaction(transactionDetails)
                                .then(function (transactionServiceRes) {
                                    if (transactionServiceRes.status === 200) {
                                        $scope.currencyBalance = Math
                                                .trunc(transactionServiceRes.data.currency.balance * 100) / 100;
                                        $scope.stockBalance = Math
                                                .trunc(transactionServiceRes.data.stock.balance * 100) / 100;
                                        $scope.submitMessages.transactionSuccess = true;
                                    }
                                }).catch(function (err) {
                                if (err.data.errCode === "INV_USER") {
                                    $scope.submitMessages.invalidRecipient = true;
                                }
                                else if (err.status === 400) {
                                    $scope.errorMessage = err.data.reason;
                                }
                            });
                        }
                    }
                }
            }
        })
})();
