DROP PROCEDURE IF EXISTS `get_account_stock_balance`;

DELIMITER $$
create procedure get_account_stock_balance(IN inputUsername VARCHAR(254)) 
# Takes a username as input and returns the balance of the account associated with the username.
# The inputUsername must be a valid username in the account_auth table.

BEGIN

set @current_datetime = NOW();

# If trading has closed and final trades finalised (ie. after 16:40:00) then use the nav value for
# today's date.
# If trading has not closed, take a day from the current date and use the nav value of that date
# (ie. yesterday's closing value).
set @current_nav_date = if(time(@transaction_datetime) < "16:40:00", 
						  date_format(date_sub(@transaction_datetime, interval 1 day), "%Y-%m-%d"), 
                          date_format(@transaction_datetime, "%Y-%m-%d"));

set @current_NAV = 
	(select Quote
	 from nav_value
	 where Quote_Date = @current_nav_date);
     
set @account_ID =
	(SELECT Account_ID
	 FROM account_auth
	 WHERE Username = inputUsername);

# Determine the most recent statement and how many stocks it was worth at the time.
set @most_recent_statement = 
	(SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT if(count(Closing_Balance) = 0, 0, Closing_Balance) * if(count(Quote) = 0, 0, Quote)
         AS Closing_Balance
		 FROM account_statement
		 JOIN nav_value
         ON account_statement.Statement_Date = nav_value.Quote_Date
		 WHERE Account_ID = @account_ID
		 order by Statement_Date desc
         limit 1) AS another_table
	);
    
set @transactions_sum = 
	# Stock contribution of transactions from first of the month to current time.
    ifnull((SELECT SUM((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) 
             AS Account_Change
	FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM account_transaction
		 JOIN nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00',
			DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY),
			Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(@current_datetime, '%Y-%m-01') 
			AND @current_datetime
		 AND Account_ID = @account_ID) AS Transactions
	), 0);
	
# Stock held by account * £ per stock. Relies on daily updated nav_value.
SELECT @transactions_sum + @most_recent_statement AS balance;

END $$
DELIMITER ;

# call get_account_balance("alistair.john.madden@gmail.com");