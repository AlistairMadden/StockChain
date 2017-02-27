drop procedure get_account_balance;

DELIMITER $$
create procedure get_account_balance(IN inputUsername VARCHAR(50)) 
BEGIN

# Stock held by account * £ per stock
select (Closing_Balance + Account_Change)/(select quote from stockchain.nav_value order by Quote_Date desc limit 1) as balance
from
	# Previous statement stock determination (if exists)
	(select ifnull(
		(select Closing_Balance * Quote
		FROM stockchain.accountstatement
		join stockchain.nav_value
		on date(stockchain.accountstatement.Statement_Date) = stockchain.nav_value.Quote_Date
		WHERE Statement_Date = 
			(select MAX(stockchain.accountstatement.Statement_Date) 
			from stockchain.accountstatement 
			where Account_ID = 
				(select Account_ID 
				from stockchain.accountauth 
				where username = inputUsername
				)
			)
		limit 1
        ), 0) AS Closing_Balance
	) as MostRecentBalance
    
	cross join

	# Recent transactions stock determination
	(Select SUM(CASE Transactions.Transaction_Code WHEN "C" THEN Transactions.Transaction_Amount * Transactions.Quote WHEN "D" 
	THEN -Transactions.Transaction_Amount * Transactions.Quote END) AS Account_Change 
    FROM
		(SELECT Transaction_Amount, Transaction_Code, Quote
		FROM stockchain.accounttransaction
        join stockchain.nav_value
        on date(if(time(Transaction_DateTime) < "16:40:00", date_sub(Transaction_DateTime, interval 1 day), Transaction_DateTime)) = nav_value.Quote_Date
		WHERE Transaction_DateTime between DATE_FORMAT(NOW() ,'%Y-%m-01') AND NOW() 
        AND Account_ID = 
			(select Account_ID 
            from accountauth 
            where username = inputUsername
            )
		) AS Transactions
	) AS TransactionsTotal;
END $$
DELIMITER ;

call get_account_balance("alistair.john.madden@gmail.com");
