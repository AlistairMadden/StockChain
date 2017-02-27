/**
 * Created by Alistair on 20/01/2017.
 */

(function() {
    'use strict';

    angular.module('api.TransactionService', [])
        .factory('TransactionService', function($http) {
            var transactionService = {};

            function makeTransaction(transactionDetails) {
                return $http.post('/api/makeTransaction', transactionDetails).then(function(res) {
                    return res;
                });
            }

            transactionService.makeTransaction = function(transactionDetails) {
                return makeTransaction(transactionDetails);
            };

            transactionService.makeTransactionCurrency = function (transactionDetails, currency) {
                transactionDetails.currency = currency;
                return makeTransaction(transactionDetails);
            };

            transactionService.getAccountTransactions = function() {
                return $http.get('/api/getAccountTransactions').then(function (res) {
                    return res;
                })
            };

            return transactionService;
        })
})();