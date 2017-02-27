drop procedure makeTransaction;

DELIMITER $$
create procedure makeTransaction(IN fromUser VARCHAR(50), toUser VARCHAR(50), amount decimal(15,5))
begin
set @current_datetime = NOW();
insert into stockchain.accounttransaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) VALUES ((SELECT Account_ID from stockchain.accountauth where username = toUser), @current_datetime, amount, "C", "GBP", (SELECT Account_ID from stockchain.accountauth where username = fromUser));
insert into stockchain.accounttransaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) VALUES ((SELECT Account_ID from stockchain.accountauth where username = fromUser), @current_datetime, amount, "D", "GBP", (SELECT Account_ID from stockchain.accountauth where username = toUser));
end$$
DELIMITER ;