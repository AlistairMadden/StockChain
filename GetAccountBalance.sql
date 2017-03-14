drop procedure get_account_balance;

DELIMITER $$
create procedure get_account_balance(IN inputUsername VARCHAR(50)) 
# Takes a username as input and returns the balance of the account associated with the username.
# Returns an empty set if no such username exists.

BEGIN

# Stock held by account * £ per stock. Relies on daily updated nav_value.
SELECT 
    ((Closing_Balance + IFNULL(Account_Change, 0)) / (SELECT quote
													  FROM stockchain.nav_value
													  ORDER BY Quote_Date DESC
                                                      LIMIT 1)) AS balance
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
    
JOIN

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

call get_account_balance("alistair.john.madden@gmail.com");
