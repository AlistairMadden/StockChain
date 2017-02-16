drop procedure update_share_statement;

DELIMITER $$
create procedure update_share_statement() 
BEGIN
insert into stockchain.asset_share_statement 
select "2017-02-11" AS Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0)
AS Closing_Balance from

	# Previous statement determination 
	(select ifnull((select Closing_Balance 
	FROM stockchain.asset_share_statement
	WHERE Statement_Date = (select MAX(stockchain.asset_share_statement.Statement_Date) from stockchain.asset_share_statement)
    limit 1), 0) AS Closing_Balance)
	AS CarriedForwardBalance

	cross join

	# New transactions determination
	(Select SUM(CASE Transactions.Transaction_Code WHEN "D" THEN Transactions.Transaction_Amount * Transactions.Share_Price 
	WHEN "C" THEN -(Transactions.Transaction_Amount * Transactions.Share_Price) END) AS Account_Change FROM
		(SELECT Transaction_Amount, Transaction_Code, Share_Price
		FROM stockchain.asset_share_transaction
		WHERE Transaction_DateTime between DATE_SUB("2017-02-11 17:00", INTERVAL 0.5 day) AND NOW())
		AS Transactions) 
	AS TransactionsTotal;

END $$
DELIMITER ;