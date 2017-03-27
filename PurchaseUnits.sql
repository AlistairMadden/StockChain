DROP PROCEDURE IF EXISTS `purchase_units`;

DELIMITER $$
create procedure purchase_units(in units int, counterparty_key char(111))
# Inserts the value of the number of input units into the asset_cash_transaction table

BEGIN

set @transaction_datetime = NOW();

# Set the correct statement datetime
set @transaction_nav_date = if(time(@transaction_datetime) < "16:40:00", 
						  date_format(date_sub(@transaction_datetime, interval 1 day), "%Y-%m-%d"), 
                          date_format(@transaction_datetime, "%Y-%m-%d"));

insert into asset_cash_transaction (Transaction_DateTime, Transaction_Amount, Transaction_Code, Counterparty_ID)

select @transaction_datetime AS Transaction_DateTime, 
	   nav_value_conversion.Amount AS Transaction_Amount,
       "D" AS Transaction_Code,
       Account_ID AS Counterparty_ID
       
from account_auth 

cross join (select units * Quote AS Amount
			from nav_value
            where Quote_Date = @transaction_nav_date) AS nav_value_conversion
            
where Openchain_Key = counterparty_key;

END $$
DELIMITER ;

# call purchase_units(50, 'xprv9s21ZrQH143K3pJT7tWRXhkdbQGJ7toc2BbQwiEfSwLWguCuFPsLkyTArQXuQUSbosgVPFESKaDq6o5XztStvMLw1DHC4eG3yhcwnLurNoH');