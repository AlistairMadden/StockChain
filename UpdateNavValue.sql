DROP PROCEDURE IF EXISTS `update_nav_value`;

DELIMITER $$
create procedure update_nav_value() 
# Inserts the new NAV calculated from the closing balance of cash and shares held,
# plus the number of units of the fund issued.

BEGIN

set @update_datetime = NOW();

# Set the correct statement datetime
set @update_datetime = if(time(@update_datetime) < "16:40:00", 
						  date_format(date_sub(@update_datetime, interval 1 day), "%Y-%m-%d 16:40:00"), 
                          date_format(@update_datetime, "%Y-%m-%d 16:40:00"));

# The total of all assets held by the fund
set @total_assets = (select asset_share_statement.Closing_Balance 
					 from asset_share_statement 
					 where asset_share_statement.Statement_Date = date(@update_datetime)) + 
					(select asset_cash_statement.Closing_Balance 
					 from asset_cash_statement 
					 where asset_cash_statement.Statement_Date = date(@update_datetime));

# Number of units of the fund that have been issued
set @units_issued = (select SUM(account_transaction.Transaction_Amount * Quote) 
					 from account_transaction
					 join nav_value
					 on Date(account_transaction.Transaction_DateTime) = Quote_Date
					 where account_transaction.Counterparty_ID = 0);

insert into nav_value

# If no units issued or no assets
select date(@update_datetime), ifnull(@units_issued/@total_assets, 1);

END $$
DELIMITER ;

call update_nav_value();
