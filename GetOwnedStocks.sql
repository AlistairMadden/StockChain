drop procedure get_owned_stocks;

DELIMITER $$
create procedure get_owned_stocks() 
BEGIN

select stockchain.asset_share_transaction.Ticker_Symbol, SUM(CASE stockchain.asset_share_transaction.Transaction_Code 
	WHEN "D" THEN stockchain.asset_share_transaction.Transaction_Amount 
    WHEN "C" THEN -stockchain.asset_share_transaction.Transaction_Amount END) AS Amount
from stockchain.asset_share_transaction
group by stockchain.asset_share_transaction.Ticker_Symbol;

END $$
DELIMITER ;

call get_owned_stocks();