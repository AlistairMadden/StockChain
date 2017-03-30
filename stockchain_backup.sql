CREATE DATABASE  IF NOT EXISTS `stockchain` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `stockchain`;
-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: stockchain
-- ------------------------------------------------------
-- Server version	5.7.17-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_auth`
--

DROP TABLE IF EXISTS `account_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_auth` (
  `Account_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  `Password_Hash` char(60) NOT NULL,
  PRIMARY KEY (`Account_ID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account_statement`
--

DROP TABLE IF EXISTS `account_statement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_statement` (
  `Account_ID` int(10) unsigned NOT NULL,
  `Statement_Date` date NOT NULL,
  `Closing_Balance` decimal(15,5) unsigned NOT NULL,
  PRIMARY KEY (`Account_ID`,`Statement_Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account_transaction`
--

DROP TABLE IF EXISTS `account_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_transaction` (
  `Transaction_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Account_ID` int(10) unsigned NOT NULL,
  `Transaction_DateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Transaction_Amount` decimal(15,5) unsigned NOT NULL,
  `Transaction_Code` varchar(3) NOT NULL,
  `Transaction_Currency` varchar(3) NOT NULL,
  `Counterparty_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Transaction_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_cash_statement`
--

DROP TABLE IF EXISTS `asset_cash_statement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_cash_statement` (
  `Statement_Date` date NOT NULL,
  `Closing_Balance` float NOT NULL,
  PRIMARY KEY (`Statement_Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_cash_transaction`
--

DROP TABLE IF EXISTS `asset_cash_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_cash_transaction` (
  `Transaction_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Transaction_DateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Transaction_Amount` decimal(15,2) NOT NULL,
  `Transaction_Code` varchar(3) NOT NULL,
  `Counterparty_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Transaction_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_share_statement`
--

DROP TABLE IF EXISTS `asset_share_statement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_share_statement` (
  `Statement_Date` date NOT NULL,
  `Closing_Balance` decimal(15,2) NOT NULL,
  PRIMARY KEY (`Statement_Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_share_transaction`
--

DROP TABLE IF EXISTS `asset_share_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_share_transaction` (
  `Trade_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Ticker_Symbol` varchar(5) NOT NULL,
  `Share_Price` decimal(8,2) NOT NULL,
  `Transaction_DateTime` datetime NOT NULL,
  `Transaction_Amount` int(10) unsigned NOT NULL,
  `Transaction_Code` varchar(3) NOT NULL,
  PRIMARY KEY (`Trade_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nav_value`
--

DROP TABLE IF EXISTS `nav_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nav_value` (
  `Quote_Date` date NOT NULL,
  `Quote` decimal(8,6) unsigned NOT NULL,
  PRIMARY KEY (`Quote_Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'stockchain'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_account_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `get_account_balance`(IN inputUsername VARCHAR(50))
BEGIN

set @current_datetime = NOW();

# If trading has closed and final trades finalised (ie. after 16:40:00) then use the nav value for
# today's date.
# If trading has not closed, take a day from the current date and use the nav value of that date
# (ie. yesterday's closing value).
set @current_nav_date = if(time(@current_datetime) < "16:40:00", 
						  date_format(date_sub(@current_datetime, interval 1 day), "%Y-%m-%d"), 
                          date_format(@current_datetime, "%Y-%m-%d"));

set @current_NAV = 
	(select Quote
	 from nav_value
	 where Quote_Date = @current_nav_date);
     
set @account_ID =
	(SELECT Account_ID
	 FROM account_auth
	 WHERE Username = inputUsername);

# Determine the most recent statement and how many stocks it was worth at the time.
set @most_recent_statement = 
	(SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT if(count(Closing_Balance) = 0, 0, Closing_Balance) * if(count(Quote) = 0, 0, Quote)
         AS Closing_Balance
		 FROM account_statement
		 JOIN nav_value
         ON account_statement.Statement_Date = nav_value.Quote_Date
		 WHERE Account_ID = @account_ID
		 order by Statement_Date desc
         limit 1) AS another_table
	);
    
set @transactions_sum = 
	# Stock contribution of transactions from first of the month to current time.
    ifnull((SELECT SUM((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) 
             AS Account_Change
	FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM account_transaction
		 JOIN nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00',
			DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY),
			Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(@current_datetime, '%Y-%m-01') 
			AND @current_datetime
		 AND Account_ID = @account_ID) AS Transactions
	), 0);
	
# Stock held by account * £ per stock. Relies on daily updated nav_value.
SELECT (@most_recent_statement + @transactions_sum) / @current_NAV AS balance;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_account_stock_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `get_account_stock_balance`(IN inputUsername VARCHAR(50))
BEGIN

set @current_datetime = NOW();

# If trading has closed and final trades finalised (ie. after 16:40:00) then use the nav value for
# today's date.
# If trading has not closed, take a day from the current date and use the nav value of that date
# (ie. yesterday's closing value).
set @current_nav_date = if(time(@transaction_datetime) < "16:40:00", 
						  date_format(date_sub(@transaction_datetime, interval 1 day), "%Y-%m-%d"), 
                          date_format(@transaction_datetime, "%Y-%m-%d"));

set @current_NAV = 
	(select Quote
	 from nav_value
	 where Quote_Date = @current_nav_date);
     
set @account_ID =
	(SELECT Account_ID
	 FROM account_auth
	 WHERE Username = inputUsername);

# Determine the most recent statement and how many stocks it was worth at the time.
set @most_recent_statement = 
	(SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT if(count(Closing_Balance) = 0, 0, Closing_Balance) * if(count(Quote) = 0, 0, Quote)
         AS Closing_Balance
		 FROM account_statement
		 JOIN nav_value
         ON account_statement.Statement_Date = nav_value.Quote_Date
		 WHERE Account_ID = @account_ID
		 order by Statement_Date desc
         limit 1) AS another_table
	);
    
set @transactions_sum = 
	# Stock contribution of transactions from first of the month to current time.
    ifnull((SELECT SUM((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) 
             AS Account_Change
	FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM account_transaction
		 JOIN nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00',
			DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY),
			Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(@current_datetime, '%Y-%m-01') 
			AND @current_datetime
		 AND Account_ID = @account_ID) AS Transactions
	), 0);
	
# Stock held by account * £ per stock. Relies on daily updated nav_value.
SELECT @transactions_sum + @most_recent_statement AS balance;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_account_transactions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `get_account_transactions`(IN inputUsername varchar(50))
begin
select ifnull((select Username from account_auth where Account_ID = Counterparty_ID), "StockChain") as Counterparty, Transaction_Amount, Transaction_DateTime, Transaction_Code
FROM account_transaction
where Account_ID = (select Account_ID from account_auth where username = inputUsername);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_owned_stocks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `get_owned_stocks`()
BEGIN

select asset_share_transaction.Ticker_Symbol, SUM(CASE asset_share_transaction.Transaction_Code 
	WHEN "D" THEN asset_share_transaction.Transaction_Amount 
    WHEN "C" THEN -asset_share_transaction.Transaction_Amount END) AS Amount
from asset_share_transaction
group by asset_share_transaction.Ticker_Symbol;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `make_transaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `make_transaction`(IN fromUser VARCHAR(50), toUser VARCHAR(50), amount decimal(15,5))
begin

set @current_datetime = NOW();

insert into account_transaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) 
VALUES ((SELECT Account_ID from account_auth where Username = toUser), @current_datetime, amount, "C", "GBP", (SELECT Account_ID from account_auth where Username = fromUser));

insert into account_transaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) 
VALUES ((SELECT Account_ID from account_auth where Username = fromUser), @current_datetime, amount, "D", "GBP", (SELECT Account_ID from account_auth where Username = toUser));

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `purchase_units` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `purchase_units`(in amount int, accountUsername varchar(50))
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_account_statement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `update_account_statement`()
BEGIN
insert into account_statement
select CarriedForwardBalance.Account_ID, CarriedForwardBalance.Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(Transactions.Account_Change, 0) AS Closing_Balance 
from 
	(select account_auth.Account_ID,  DATE_FORMAT(now(), '%Y-%m-01') AS Statement_Date, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance 
	from account_auth
		LEFT JOIN
		(SELECT * 
        FROM account_statement
		WHERE Statement_Date = DATE_FORMAT(date_sub(now(), interval 1 month), '%Y-%m-01')) AS MostRecentStatements
		ON account_auth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN
(Select Account_ID, DATE_FORMAT(now(), '%Y-%m-01') as Statement_Date, ((1/Quote) * Account_Change) as Account_Change
from
	(Select Account_ID, SUM(CASE Transactions.Transaction_Code WHEN "C" THEN Transactions.Transaction_Amount * Transactions.Quote WHEN "D" 
		THEN -Transactions.Transaction_Amount * Transactions.Quote END) AS Account_Change 
		FROM
			(SELECT Transaction_Amount, Transaction_Code, Quote, Account_ID
			FROM 
				account_transaction
				join nav_value
				on date(if(time(Transaction_DateTime) < "16:40:00", date_sub(Transaction_DateTime, interval 1 day), Transaction_DateTime)) = nav_value.Quote_Date
				WHERE Transaction_DateTime between DATE_FORMAT(date_sub(now(), interval 1 month), '%Y-%m-01') AND DATE_FORMAT(now(), '%Y-%m-01')
			) AS Transactions 
		group by Account_ID) as account_change
	join nav_value
    on date_format(now(), '%Y-%m-01') = nav_value.Quote_Date) as Transactions
ON CarriedForwardBalance.Account_ID = Transactions.Account_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_cash_statement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `update_cash_statement`()
BEGIN

set @update_datetime = NOW();

# Set the correct statement datetime
set @update_datetime = if(time(@update_datetime) < "16:40:00", 
						  date_format(date_sub(@update_datetime, interval 1 day), "%Y-%m-%d 16:40:00"), 
                          date_format(@update_datetime, "%Y-%m-%d 16:40:00"));

insert into asset_cash_statement (Account_ID, Statement_Date, Closing_Balance)
select 0 AS Account_ID, date(@update_datetime) AS Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0)
AS Closing_Balance from

    # Previous statement determination 
    (select ifnull((select Closing_Balance 
    FROM asset_cash_statement
    WHERE Statement_Date = date(date_sub(@update_datetime, interval 1 day))
    limit 1), 0) AS Closing_Balance)
    AS CarriedForwardBalance

    cross join

    # New transactions determination
    (Select SUM(CASE Transactions.Transaction_Code 
				WHEN "D" THEN Transactions.Transaction_Amount
				WHEN "C" THEN -Transactions.Transaction_Amount END) AS Account_Change 
	 FROM
        (SELECT Transaction_Amount, Transaction_Code
         FROM asset_cash_transaction
         WHERE Transaction_DateTime between DATE_SUB(@update_datetime, INTERVAL 1 day) AND @update_datetime)
         AS Transactions) 
    AS TransactionsTotal;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_nav_value` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=current_user PROCEDURE `update_nav_value`()
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-28 13:50:24
