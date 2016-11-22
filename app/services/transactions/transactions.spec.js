/**
 * Created by Alistair on 14/11/2016.
 */

describe('transactionsFactory', function() {
    var transactions;
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
    var txnId1 = {
        id: 1,
        ref: 'info from stock broker',
        time: '20161114T204229Z',
        stock: 'StockChain'
    };

    // Before each test load our api.transactions module
    beforeEach(angular.mock.module('api.transactions'));

    // Before each test set our injected transactions factory (_transactions_) to our local transactions variable
    beforeEach(inject(function(_transactions_) {
        transactions = _transactions_;
    }));

    // A simple test to verify the transactions factory exists
    it('should exist', function() {
        expect(transactions).toBeDefined();
    });

    // A set of tests for our transactions.all() method
    describe('.all()', function() {
        // A simple test to verify the method all exists
        it('should exist', function() {
            expect(transactions.all).toBeDefined();
        });

        // A test to verify that calling all() returns the array of transactions hard-coded into transactions.js
        it('should return a hard-coded list of transactions', function() {
            expect(transactions.all()).toEqual(transactionsList);
        });
    });

    // A set of tests for our transactions.findById() method
    describe('.findById()', function() {
        // A simple test to verify the method findById exists
        it('should exist', function() {
            expect(transactions.findById).toBeDefined();
        });

        it('should return the transaction with id if it exists', function() {
            expect(transactions.findById(1)).toEqual(txnId1);
        });

        // A test to verify that calling findById() with an id that doesn't exist, in this case 'ABC', returns undefined
        it('should return undefined if the transaction cannot be found', function() {
            expect(transactions.findById('ABC')).not.toBeDefined();
        });
    });
});