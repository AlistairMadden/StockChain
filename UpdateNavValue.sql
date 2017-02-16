drop procedure update_nav_value;

DELIMITER $$
create procedure update_nav_value() 
BEGIN

insert into stockchain.nav_value
select curdate(), 1/(((select stockchain.asset_share_statement.Closing_Balance from stockchain.asset_share_statement order by stockchain.asset_share_statement.Statement_Date desc limit 1) + 
	(select stockchain.asset_cash_statement.Closing_Balance from stockchain.asset_cash_statement order by stockchain.asset_cash_statement.Statement_Date desc limit 1))/(select SUM(stockchain.accounttransaction.Transaction_Amount * Quote) 
from stockchain.accounttransaction
join stockchain.nav_value
on Date(stockchain.accounttransaction.Transaction_DateTime) = Quote_Date
where stockchain.accounttransaction.Counterparty_ID = 0));

END $$
DELIMITER ;

select curdate(), 1/(((select stockchain.asset_share_statement.Closing_Balance from stockchain.asset_share_statement order by stockchain.asset_share_statement.Statement_Date desc limit 1) + 
	(select stockchain.asset_cash_statement.Closing_Balance from stockchain.asset_cash_statement order by stockchain.asset_cash_statement.Statement_Date desc limit 1))/(select SUM(stockchain.accounttransaction.Transaction_Amount * Quote) 
from stockchain.accounttransaction
join stockchain.nav_value
on Date(stockchain.accounttransaction.Transaction_DateTime) = Quote_Date
where stockchain.accounttransaction.Counterparty_ID = 0))