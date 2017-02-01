/**
 * Created by Alistair on 20/01/2017.
 */

(function() {
    'use strict';

    angular.module('api.TransactionService', [])
        .factory('TransactionService', function($http) {
            var transactionService = {};

            transactionService.makeTransaction = function(transactionDetails) {
                return $http.post('/api/makeTransaction', transactionDetails).then(function(res) {
                    return res;
                });
            };

            return transactionService;
        })
})();