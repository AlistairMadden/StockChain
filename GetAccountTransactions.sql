drop procedure getAccountTransactions;

DELIMITER $$
create procedure getAccountTransactions(IN inputUsername varchar(50))
begin
select ifnull((select username from stockchain.accountauth where Account_ID = Counterparty_ID), "StockChain") as Counterparty, Transaction_Amount, Transaction_DateTime, Transaction_Code
FROM stockchain.accounttransaction
where Account_ID = (select Account_ID from stockchain.accountauth where username = "alistair.madden@me.com");
end $$
DELIMITER ;