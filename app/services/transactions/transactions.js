/**
 * Created by Alistair on 14/11/2016.
 */

(function() {
    'use strict';

    // Creating the module and factory we referenced in the beforeEach blocks in our test file
    angular.module('api.transactions', [])
        .factory('transactions', function() {
            var transactions = {};

            var transactionsList = [
                {
                    id: 1,
                    ref: 'info from stock broker',
                    time: '20161114T204229Z',
                    stock: 'StockChain'
                },
                {
                    id: 2,
                    ref: 'info from stock broker',
                    time: '20161114T204229Z',
                    stock: 'AMD'
                }
            ];

            transactions.all = function () {
                return transactionsList;
            };

            transactions.findById = function (id) {
                return transactionsList.find(function (transaction) {
                    return transaction.id === id;
                });
            };

            return transactions;
        });
})();