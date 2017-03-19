DROP PROCEDURE IF EXISTS `update_cash_statement`;

DELIMITER $$
create procedure update_cash_statement()
# Inserts a new record into the asset_cash_statement table representing
# the amount of cash held by the fund at the end of the day's trading.
#
# Note that updating of the share statement is performed by the back end.

BEGIN

set @update_datetime = NOW();

# Set the correct statement datetime
set @update_datetime = if(time(@update_datetime) < "16:40:00", 
						  date_format(date_sub(@update_datetime, interval 1 day), "%Y-%m-%d 16:40:00"), 
                          date_format(@update_datetime, "%Y-%m-%d 16:40:00"));

insert into asset_cash_statement (Account_ID, Statement_Date, Closing_Balance)
select 0 AS Account_ID, date(@update_datetime) AS Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0)
AS Closing_Balance from

    # Previous statement determination 
    (select ifnull((select Closing_Balance 
    FROM asset_cash_statement
    WHERE Statement_Date = date(date_sub(@update_datetime, interval 1 day))
    limit 1), 0) AS Closing_Balance)
    AS CarriedForwardBalance

    cross join

    # New transactions determination
    (Select SUM(CASE Transactions.Transaction_Code 
				WHEN "D" THEN Transactions.Transaction_Amount
				WHEN "C" THEN -Transactions.Transaction_Amount END) AS Account_Change 
	 FROM
        (SELECT Transaction_Amount, Transaction_Code
         FROM asset_cash_transaction
         WHERE Transaction_DateTime between DATE_SUB(@update_datetime, INTERVAL 1 day) AND @update_datetime)
         AS Transactions) 
    AS TransactionsTotal;

END $$
DELIMITER ;

# call update_cash_statement();
