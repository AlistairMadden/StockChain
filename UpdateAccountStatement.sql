DROP PROCEDURE IF EXISTS `update_account_statement`;

DELIMITER $$
create procedure update_account_statement()
# Sums the transactions over the past month and the previous account statement
# and inserts the new statement into the account_statement table.

BEGIN
insert into account_statement
select CarriedForwardBalance.Account_ID, CarriedForwardBalance.Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(Transactions.Account_Change, 0) AS Closing_Balance 
from 
	(select account_auth.Account_ID,  DATE_FORMAT(now(), '%Y-%m-01') AS Statement_Date, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance 
	from account_auth
		LEFT JOIN
		(SELECT * 
        FROM account_statement
		WHERE Statement_Date = DATE_FORMAT(date_sub(now(), interval 1 month), '%Y-%m-01')) AS MostRecentStatements
		ON account_auth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN
(Select Account_ID, DATE_FORMAT(now(), '%Y-%m-01') as Statement_Date, ((1/Quote) * Account_Change) as Account_Change
from
	(Select Account_ID, SUM(CASE Transactions.Transaction_Code WHEN "C" THEN Transactions.Transaction_Amount * Transactions.Quote WHEN "D" 
		THEN -Transactions.Transaction_Amount * Transactions.Quote END) AS Account_Change 
		FROM
			(SELECT Transaction_Amount, Transaction_Code, Quote, Account_ID
			FROM 
				account_transaction
				join nav_value
				on date(if(time(Transaction_DateTime) < "16:40:00", date_sub(Transaction_DateTime, interval 1 day), Transaction_DateTime)) = nav_value.Quote_Date
				WHERE Transaction_DateTime between DATE_FORMAT(date_sub(now(), interval 1 month), '%Y-%m-01') AND DATE_FORMAT(now(), '%Y-%m-01')
			) AS Transactions 
		group by Account_ID) as account_change
	join nav_value
    on date_format(now(), '%Y-%m-01') = nav_value.Quote_Date) as Transactions
ON CarriedForwardBalance.Account_ID = Transactions.Account_ID;
END $$
DELIMITER ;

# call update_account_statement()
