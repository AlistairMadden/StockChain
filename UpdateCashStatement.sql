drop procedure update_cash_statement;

DELIMITER $$
create procedure update_cash_statement() 
BEGIN

insert into stockchain.asset_cash_statement 
values(curdate(), (select SUM(CASE stockchain.asset_cash_transactions.Transaction_ID 
	WHEN "D" THEN stockchain.asset_cash_transactions.Transaction_Amount 
    WHEN "C" THEN -stockchain.asset_cash_transactions.Transaction_Amount END) from stockchain.asset_cash_transactions));

END $$
DELIMITER ;