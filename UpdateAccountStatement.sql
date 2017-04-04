DROP PROCEDURE IF EXISTS `update_account_statement`;

DELIMITER $$
create procedure update_account_statement()
# Sums the transactions over the past month and the previous account statement
# and inserts the new statement into the account_statement table.

BEGIN

set @update_date = date_format(NOW(), "%Y-%m-%01");

# Set the correct statement datetime
set @previous_update_date = date_format(date_sub(@update_date, interval 1 month), "%Y-%m-%01");

insert into account_statement
select CarriedForwardBalance.Account_ID, @update_date, CarriedForwardBalance.Closing_Balance + IFNULL(Transactions.Account_Change, 0) AS Closing_Balance 
from 
	(select account_auth.Account_ID, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance 
	from account_auth
		LEFT JOIN
		(SELECT * 
        FROM account_statement
		WHERE Statement_Date = @previous_update_date) AS MostRecentStatements
		ON account_auth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN
(Select Account_ID, ((1/Quote) * Account_Change) as Account_Change
from
	(Select Account_ID, SUM(CASE Transactions.Transaction_Code WHEN "C" THEN Transactions.Transaction_Amount * Transactions.Quote WHEN "D" 
		THEN -Transactions.Transaction_Amount * Transactions.Quote END) AS Account_Change 
		FROM
			(SELECT Transaction_Amount, Transaction_Code, Quote, Account_ID
			FROM 
				account_transaction
				join nav_value
				on date(if(time(Transaction_DateTime) < "16:40:00", date_sub(Transaction_DateTime, interval 1 day), Transaction_DateTime)) = nav_value.Quote_Date
				WHERE Transaction_DateTime between @previous_update_date AND @update_date
			) AS Transactions 
		group by Account_ID) as account_change
	join nav_value
    # account balances updated at midnight (ie. before trading on the statement date)
    on date_sub(@update_date, interval 1 day) = nav_value.Quote_Date) as Transactions
ON CarriedForwardBalance.Account_ID = Transactions.Account_ID;

END $$
DELIMITER ;

# call update_account_statement()
