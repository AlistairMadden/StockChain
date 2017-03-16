DROP PROCEDURE IF EXISTS `get_account_balance`;

DELIMITER $$
create procedure get_account_balance(IN inputUsername VARCHAR(50)) 
# Takes a username as input and returns the balance of the account associated with the username.
# The inputUsername must be a valid username in the account_auth table.

BEGIN

set @current_NAV = 
	(SELECT Quote
	 FROM nav_value
	 ORDER BY Quote_Date DESC
	 LIMIT 1);

set @most_recent_statement = 
	(SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT if(count(Closing_Balance) = 0, 0, Closing_Balance) * if(count(Quote) = 0, 0, Quote) AS Closing_Balance
		 FROM account_statement
		 JOIN nav_value
         ON DATE(account_statement.Statement_Date) = nav_value.Quote_Date
		 WHERE Statement_Date = 
			(SELECT MAX(account_statement.Statement_Date)
			 FROM account_statement
			 WHERE Account_ID = 
				(SELECT Account_ID
				 FROM account_auth
				 WHERE Username = inputUsername)
			)
		 AND Account_ID = 
			(SELECT Account_ID
			 FROM account_auth
			 WHERE Username = inputUsername)
		 ) AS another_table
	);
    
set @transactions_sum = 
	# Stock contribution of transactions from first of the month to current time.
    ifnull((SELECT ((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) AS Account_Change
	 FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM account_transaction
		 JOIN nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00', DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY), Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(NOW(), '%Y-%m-01') AND NOW()
		 AND Account_ID = (SELECT Account_ID
						   FROM account_auth
						   WHERE Username = inputUsername)
		) AS Transactions
	), 0);
	
# Stock held by account * £ per stock. Relies on daily updated nav_value.
SELECT (@transactions_sum + @most_recent_statement) / @current_NAV;

END $$
DELIMITER ;

# call get_account_balance("alistair.john.madden@gmail.com");
