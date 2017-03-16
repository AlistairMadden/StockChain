DROP PROCEDURE IF EXISTS `get_owned_stocks`;

DELIMITER $$
create procedure get_owned_stocks() 
BEGIN

select asset_share_transaction.Ticker_Symbol, SUM(CASE asset_share_transaction.Transaction_Code 
	WHEN "D" THEN asset_share_transaction.Transaction_Amount 
    WHEN "C" THEN -asset_share_transaction.Transaction_Amount END) AS Amount
from asset_share_transaction
group by asset_share_transaction.Ticker_Symbol;

END $$
DELIMITER ;

call get_owned_stocks();