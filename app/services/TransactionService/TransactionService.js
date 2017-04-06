/**
 * Created by Alistair on 20/01/2017.
 */

(function() {
    'use strict';

    angular.module('api.TransactionService', [])
        .factory('TransactionService', function($http) {
            var transactionService = {};

            transactionService.makeTransaction = function(transactionDetails, currency) {
                transactionDetails.currency = currency;
                return $http.post('/api/makeTransaction', transactionDetails).then(function(res) {
                    return res;
                });
            }

            transactionService.getAccountTransactions = function() {
                return $http.get('/api/getAccountTransactions').then(function (res) {
                    return res;
                })
            };

            transactionService.addFundTransation = function() {
                return $http.post('/api/addFunds', {}).then(function (res) {
                    return res;
                })
            };

            return transactionService;
        })
})();