drop procedure get_account_stock_balance;

## Possible code duplication - Stock balance can be derived from the balance in £s (or visa versa)

DELIMITER $$
create procedure get_account_stock_balance(IN inputUsername VARCHAR(50))
BEGIN

# Stock held by account
SELECT (Closing_Balance + IFNULL(Account_Change, 0)) as balance
FROM
	# Previous statement stock determination
    (SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT Closing_Balance * Quote AS Closing_Balance
		 FROM stockchain.accountstatement
		 JOIN stockchain.nav_value 
         ON DATE(stockchain.accountstatement.Statement_Date) = stockchain.nav_value.Quote_Date
		 WHERE Statement_Date = (SELECT MAX(stockchain.accountstatement.Statement_Date)
		 						 FROM stockchain.accountstatement
								 WHERE Account_ID = (SELECT Account_ID
													 FROM stockchain.accountauth
													 WHERE username = inputUsername)
								)
		 AND Account_ID = (SELECT Account_ID
						   FROM stockchain.accountauth
						   WHERE username = inputUsername)
		 ) AS another_table
	) AS previous_statement
    
LEFT JOIN

	# Stock contribution of transactions from first of the month to current time.
    (SELECT SUM((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) AS Account_Change
	 FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM stockchain.accounttransaction
		 JOIN stockchain.nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00', DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY), Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(NOW(), '%Y-%m-01') AND NOW()
		 AND Account_ID = (SELECT Account_ID
						   FROM accountauth
						   WHERE username = inputUsername)
		) AS Transactions
	) AS table2 
ON Account_Change;

END $$
DELIMITER ;

call get_account_stock_balance("alistair.madden@me.com");
