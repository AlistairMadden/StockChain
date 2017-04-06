DROP PROCEDURE IF EXISTS `make_transaction`;

DELIMITER $$
create procedure make_transaction(IN fromUser VARCHAR(254), toUser VARCHAR(254), amount decimal(15,5), currency varchar(5))
# Insert two records into account_transaction (party, counter-party) to represent a transaction.

begin

set @current_datetime = NOW();

insert into account_transaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) 
VALUES ((SELECT Account_ID from account_auth where Username = toUser), @current_datetime, amount, "C", currency, (SELECT Account_ID from account_auth where Username = fromUser));

insert into account_transaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) 
VALUES ((SELECT Account_ID from account_auth where Username = fromUser), @current_datetime, amount, "D", currency, (SELECT Account_ID from account_auth where Username = toUser));

end$$

DELIMITER ;