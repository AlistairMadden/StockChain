DROP PROCEDURE IF EXISTS `purchase_units`;

DELIMITER $$
create procedure purchase_units(in amount int, accountUsername varchar(254))
# Adds funds equal to amount to the account specified by accountUsername. A double entry is made
# in the asset_cash_transaction and account_transaction tables.

BEGIN

set @transaction_datetime = NOW();

set @account_ID = (select Account_ID 
		from account_auth 
        where Username = accountUsername);

insert into asset_cash_transaction (Transaction_DateTime, Transaction_Amount, Transaction_Code, Counterparty_ID)

select @transaction_datetime AS Transaction_DateTime, 
	   amount AS Transaction_Amount,
       "D" AS Transaction_Code,
       @account_ID AS Counterparty_ID;

insert into account_transaction (Account_ID, Transaction_DateTime, Transaction_Amount, 
	Transaction_Code, Transaction_Currency, Counterparty_ID)
    
select @account_ID as Account_ID,
	   @transaction_datetime as Transaction_DateTime,
	   amount as Transaction_Amount,
	   "C" as Transaction_Code,
	   "GBP" as Transaction_Currency,
	   0 as Counterparty_ID;

END $$
DELIMITER ;

# call purchase_units(50, "alistair.john.madden@gmail.com");