/**
 * Created by Alistair on 15/11/2016.
 */

describe('transactionsController', function() {
    var $controller, transactionsController, transactionsFactory;

    // Test transaction list
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

    // Load ui.router and our components.transactions module which we'll create next
    beforeEach(angular.mock.module('ui.router'));
    beforeEach(angular.mock.module('components.transactions'));
    beforeEach(angular.mock.module('api.transactions'));

    // Inject the $controller service to create instances of the controller (transactionsController) we want to test
    beforeEach(inject(function(_$controller_, _transactions_) {
        $controller = _$controller_;
        transactionsFactory = _transactions_;

        // Spy and force return value when transactionsFactory.all() is called
        spyOn(transactionsFactory, 'all').and.callFake(function () {
            return transactionsList;
        });
        transactionsController = $controller('transactionsController', {transactions: transactionsFactory});
    }));

    // Verify transactionsController exists
    it('should be defined', function(){
        expect(transactionsController).toBeDefined();
    });

    // Add a new test for the expected controller behavior
    it('should initialize with a call to transactions.all()', function($scope) {
        expect(transactionsFactory.all).toHaveBeenCalled();
        expect($scope.transactions).toEqual(transactionsList);
    });
});