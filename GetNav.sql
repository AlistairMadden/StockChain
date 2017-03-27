DROP PROCEDURE IF EXISTS `get_nav`;

DELIMITER $$
create procedure get_nav()
# Retrives the latest nav quote. This is specifically retrieved by
# date to reduce semantic errors.

BEGIN

set @current_datetime = NOW();

# Set the correct statement datetime
set @current_nav_date = if(time(@transaction_datetime) < "16:40:00", 
						  date_format(date_sub(@transaction_datetime, interval 1 day), "%Y-%m-%d"), 
                          date_format(@transaction_datetime, "%Y-%m-%d"));
                          
select Quote
from nav_value
where Quote_Date = @current_nav_date;

END $$
DELIMITER ;

# call get_nav()