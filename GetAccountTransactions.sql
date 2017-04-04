DROP PROCEDURE IF EXISTS `get_account_transactions`;

DELIMITER $$
create procedure get_account_transactions(IN inputUsername varchar(254))
begin
select ifnull((select Username from account_auth where Account_ID = Counterparty_ID), "StockChain") as Counterparty, Transaction_Amount, Transaction_DateTime, Transaction_Code
FROM account_transaction
where Account_ID = (select Account_ID from account_auth where username = inputUsername);
end $$
DELIMITER ;

call get_account_transactions("alistair.john.madden@gmail.com");