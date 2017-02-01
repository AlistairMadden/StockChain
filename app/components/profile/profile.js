(function () {
    'use strict';

    // Define the component and controller loaded in our test
    angular.module('components.profile', [])
        .controller('profileController', function ($scope, profileDetails, TransactionService) {
            $scope.profileDetails = profileDetails;
            $scope.loginInfo.loggedIn = true;

            $scope.transactionDetails = {};

            $scope.submitMessages = {};

            $scope.makeTransaction = function (transactionDetails) {
                if (transactionDetails) {
                    if (profileDetails.username === transactionDetails.username) {
                        $scope.submitMessages.selfEmail = true;
                    }
                    else if (profileDetails.balance < transactionDetails.amount) {
                        $scope.submitMessages.insufficientFunds = true;
                    }
                    else {
                        TransactionService.makeTransaction(transactionDetails).then(function(transactionServiceRes) {
                            if(transactionServiceRes.status === 200) {
                                $scope.submitMessages.transactionSuccess = true;
                            }
                        }).catch(function (err) {
                            if(err.data.errCode === "INV_USER") {
                                $scope.submitMessages.invalidRecipient = true;
                            }
                        });
                    }
                }
                else {
                    $scope.invalidTransactionDetails = true;
                }
            }
        })
})();
