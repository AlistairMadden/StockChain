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
-- Table structure for table `accountauth`
--

DROP TABLE IF EXISTS `accountauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountauth` (
  `Account_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` char(60) NOT NULL,
  PRIMARY KEY (`Account_ID`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountauth`
--

LOCK TABLES `accountauth` WRITE;
/*!40000 ALTER TABLE `accountauth` DISABLE KEYS */;
INSERT INTO `accountauth` VALUES (1,'alistair.madden@me.com','$2a$10$7VFOvMoEeQGQfaEHOXUz2uTwp3Z1JzQJ6SFZw.25UcX09TnRdgrdW'),(2,'lasttestIswear@example.com','$2a$10$X4AfGGBbp26tqjoLAwDOfeWRN4wV27xByh5yjUwpOS4e4LB1B7nn2'),(3,'alistair.john.madden@gmail.com','$2a$10$pC7G6Wv8nyJfkbVGCxnjQeZ7/MO4Ht.8uBMqlCD22yasrdUDSh636'),(4,'another.example.email@me.com','$2a$10$OagknQXk7cRRg4iNj6xyauE.3YlMoSOHMdV3XoLooxENijN/g8R9a'),(6,'aloha@jim.com','$2a$10$Z4uKl.qlzowy8ol5jFhWLuFYFS5n2VRErShY0tOQdgxfQhd0czmOC'),(7,'another@jim.com','$2a$10$cWiPaYRrWo8zuzeqEUIGYepCKHSRINSMhRt2KoAzhvjTBQIQkuU9a'),(8,'finalUser@me.com','$2a$10$qBIRUsm7H3HD2WrHYCM0N.aXOEIRXZxd4b.XlJimaSMjPaBZbg3by'),(9,'finalFinalUserISwear@cleanDB.org.uk','$2a$10$TcAH/LRfpwkUWHumdA1AtuZM9I1/My.US0w2FOzLEBa93n9xTfSfe'),(10,'alistair@me.com','$2a$10$Z6mUrMLEFKRJdI2MwPhVW.fW8G4rr2qLzZIYW07wUc8aDxFOZ6UPa'),(11,'anyone@me.com','$2a$10$aBOm.z7F/U23APIscgLh4eQp1ijVMyFL7zxIuVhjg8xKM.DPDNa92'),(12,'justanotheracCount@example.com','$2a$10$4.WkqCHese/8FaVhaBhWC.lSkyWBSLFg6AtvCtWgQ.WHZ83j8vdaO'),(15,'justanotheranotheraccount@example.com','$2a$10$m3ZXWdVNdVeG7IrEDKwBG.bp.mpUIGtFGaLk3S7VItOAVvWSdRO4K'),(16,'lolistair@gmail.com','$2a$10$MpIQ9rNn/ujNHCtXFANsuOmOiiwCjKe5KQ5ymbW5xJOxHL7Nf3yCq'),(17,'david.headley@durham.ac.uk','$2a$10$wBvxqdYs2NNTEETwlBJQy.8mLfH1JlGPZ5eB8qdLUXBR3tNp.TkaS'),(18,'alistair.madden@gmail.com','$2a$10$ngRMmygPIOEMluo9WfTtG.ec1ItJXuEDJDNNFwNHJuY43Q5tY6LkW'),(20,'aTestemail@ema','$2a$10$ClzWX1f5AOIiuTDkysy8dec22kkVPmO1rv2/Ld8ocPkYb2N7CzSpO'),(21,'whywontthiswork@email','$2a$10$df5vJs/pU4s9nt1VNFhCyevZKoIv9hvRGj4/ok.F1PPegdWM53IqS'),(22,'hihihi@12','$2a$10$dYFtCd2UMEDsApXmyc8cQubKsTRHTMJknNaikhvqpRY6n5ilo4RIm'),(23,'adffsd@asdfafsd','$2a$10$CwauX23EdfWI5ArkYKgXYe/zZpGPy2l3YiGlGTgjKCSWlpUnFXN5a'),(24,'asdff@asdf','$2a$10$/4lzm2hsqO4RTEIrG3Cd6.vTuOKIDTKuje7UxUVkACS5CrgTs2UCa'),(25,'afsdinfas@asdfafds','$2a$10$gRF4YnJ7Wr8jslOLA8SDGOkdnp21AUIu9ERBQ1l0P9I68JK9Mvaqm');
/*!40000 ALTER TABLE `accountauth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accountstatement`
--

DROP TABLE IF EXISTS `accountstatement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountstatement` (
  `Account_ID` int(10) unsigned NOT NULL,
  `Statement_Date` date NOT NULL,
  `Closing_Balance` decimal(15,5) unsigned NOT NULL,
  PRIMARY KEY (`Account_ID`,`Statement_Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountstatement`
--

LOCK TABLES `accountstatement` WRITE;
/*!40000 ALTER TABLE `accountstatement` DISABLE KEYS */;
INSERT INTO `accountstatement` VALUES (1,'2017-03-01',50555.46488),(2,'2017-03-01',0.00000),(3,'2017-03-01',90.67862),(4,'2017-03-01',0.00000),(6,'2017-03-01',0.00000),(7,'2017-03-01',0.00000),(8,'2017-03-01',0.00000),(9,'2017-03-01',0.00000),(10,'2017-03-01',0.00000),(11,'2017-03-01',0.00000),(12,'2017-03-01',0.00000),(15,'2017-03-01',0.00000),(16,'2017-03-01',0.00000),(17,'2017-03-01',0.00000),(18,'2017-03-01',0.00000),(20,'2017-03-01',0.00000),(21,'2017-03-01',0.00000),(22,'2017-03-01',0.00000),(23,'2017-03-01',0.00000),(24,'2017-03-01',0.00000),(25,'2017-03-01',0.00000);
/*!40000 ALTER TABLE `accountstatement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounttransaction`
--

DROP TABLE IF EXISTS `accounttransaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounttransaction` (
  `Transaction_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Account_ID` int(10) unsigned NOT NULL,
  `Transaction_DateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Transaction_Amount` decimal(15,5) unsigned NOT NULL,
  `Transaction_Code` varchar(3) NOT NULL,
  `Transaction_Currency` varchar(3) NOT NULL,
  `Counterparty_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Transaction_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounttransaction`
--

LOCK TABLES `accounttransaction` WRITE;
/*!40000 ALTER TABLE `accounttransaction` DISABLE KEYS */;
INSERT INTO `accounttransaction` VALUES (1,1,'2017-02-12 21:32:53',50000.00000,'C','GBP',0),(2,1,'2017-02-14 18:29:04',50.00000,'D','GBP',3),(3,3,'2017-02-14 18:29:04',50.00000,'C','GBP',1),(36,1,'2017-02-16 14:04:07',50.66000,'C','GBP',3),(37,3,'2017-02-16 14:04:07',50.66000,'D','GBP',1),(38,3,'2017-02-16 14:05:42',50666.05000,'C','GBP',1),(39,1,'2017-02-16 14:05:42',50666.05000,'D','GBP',3),(46,3,'2017-02-16 20:59:22',0.05000,'C','GBP',1),(47,1,'2017-02-16 20:59:22',0.05000,'D','GBP',3),(48,1,'2017-02-16 21:10:27',50816.10000,'C','GBP',3),(49,3,'2017-02-16 21:10:27',50816.10000,'D','GBP',1),(50,3,'2017-02-16 21:12:17',50816.10000,'C','GBP',1),(51,1,'2017-02-16 21:12:17',50816.10000,'D','GBP',3),(52,1,'2017-02-16 21:13:49',40000.00000,'C','GBP',3),(53,3,'2017-02-16 21:13:49',40000.00000,'D','GBP',1),(54,3,'2017-02-16 21:19:43',20.35000,'C','GBP',1),(55,1,'2017-02-16 21:19:43',20.35000,'D','GBP',3),(56,3,'2017-02-16 21:22:15',837.29000,'C','GBP',1),(57,1,'2017-02-16 21:22:15',837.29000,'D','GBP',3),(60,3,'2017-02-16 23:03:05',0.01000,'C','GBP',1),(61,1,'2017-02-16 23:03:05',0.01000,'D','GBP',3),(62,1,'2017-02-16 23:31:46',1.02000,'C','GBP',3),(63,3,'2017-02-16 23:31:46',1.02000,'D','GBP',1),(74,3,'2017-02-17 01:34:00',3459.00000,'C','GBP',1),(75,1,'2017-02-17 01:34:00',3459.00000,'D','GBP',3),(76,3,'2017-02-22 10:56:12',50.00000,'C','GBP',1),(77,1,'2017-02-22 10:56:12',50.00000,'D','GBP',3),(78,3,'2017-02-22 11:02:11',50.00000,'C','GBP',1),(79,1,'2017-02-22 11:02:11',50.00000,'D','GBP',3),(80,1,'2017-02-22 11:03:55',15236.50000,'C','GBP',3),(81,3,'2017-02-22 11:03:55',15236.50000,'D','GBP',1),(82,3,'2017-02-22 11:37:41',80.00000,'C','GBP',1),(83,1,'2017-02-22 11:37:41',80.00000,'D','GBP',3),(84,3,'2017-02-22 11:38:49',80.00000,'C','GBP',1),(85,1,'2017-02-22 11:38:49',80.00000,'D','GBP',3),(86,3,'2017-02-22 11:40:23',50.00000,'C','GBP',1),(87,1,'2017-02-22 11:40:23',50.00000,'D','GBP',3),(88,3,'2017-02-22 11:40:30',50.00000,'C','GBP',1),(89,1,'2017-02-22 11:40:30',50.00000,'D','GBP',3),(90,3,'2017-02-22 11:40:32',50.00000,'C','GBP',1),(91,1,'2017-02-22 11:40:32',50.00000,'D','GBP',3),(92,3,'2017-02-22 11:53:07',50.55000,'C','GBP',1),(93,1,'2017-02-22 11:53:07',50.55000,'D','GBP',3),(94,3,'2017-02-22 14:37:32',400.00000,'C','GBP',1),(95,1,'2017-02-22 14:37:32',400.00000,'D','GBP',3),(96,3,'2017-02-22 15:13:05',38.94000,'C','GBP',1),(97,1,'2017-02-22 15:13:05',38.94000,'D','GBP',3),(98,3,'2017-02-22 15:13:22',38.94000,'C','GBP',1),(99,1,'2017-02-22 15:13:22',38.94000,'D','GBP',3),(100,3,'2017-02-22 15:27:49',67.00000,'C','GBP',1),(101,1,'2017-02-22 15:27:49',67.00000,'D','GBP',3),(102,3,'2017-02-22 16:40:13',738.00000,'C','GBP',1),(103,1,'2017-02-22 16:40:13',738.00000,'D','GBP',3),(104,3,'2017-02-22 16:47:04',37.00000,'C','GBP',1),(105,1,'2017-02-22 16:47:04',37.00000,'D','GBP',3),(106,1,'2017-02-25 21:09:59',500.00000,'C','GBP',3),(107,3,'2017-02-25 21:09:59',500.00000,'D','GBP',1),(108,3,'2017-02-25 21:41:59',500.00000,'C','GBP',1),(109,1,'2017-02-25 21:41:59',500.00000,'D','GBP',3),(110,3,'2017-02-25 22:01:47',800.00000,'C','GBP',1),(111,1,'2017-02-25 22:01:47',800.00000,'D','GBP',3),(112,1,'2017-02-25 22:51:34',2474.35000,'C','GBP',3),(113,3,'2017-02-25 22:51:34',2474.35000,'D','GBP',1),(114,18,'2017-02-25 23:34:53',56.25000,'C','GBP',1),(115,1,'2017-02-25 23:34:53',56.25000,'D','GBP',18),(116,1,'2017-02-25 23:47:01',56.25000,'C','GBP',18),(117,18,'2017-02-25 23:47:01',56.25000,'D','GBP',1),(118,3,'2017-02-27 15:12:31',90.68000,'C','GBP',1),(119,1,'2017-02-27 15:12:31',90.68000,'D','GBP',3),(120,1,'2017-03-05 23:44:35',90.67000,'C','GBP',3),(121,3,'2017-03-05 23:44:35',90.67000,'D','GBP',1),(122,3,'2017-03-06 19:52:03',739.00000,'C','GBP',1),(123,1,'2017-03-06 19:52:03',739.00000,'D','GBP',3),(124,1,'2017-03-11 19:43:06',739.00000,'C','GBP',3),(125,3,'2017-03-11 19:43:06',739.00000,'D','GBP',1),(126,3,'2017-03-11 19:43:54',50646.13000,'C','GBP',1),(127,1,'2017-03-11 19:43:54',50646.13000,'D','GBP',3),(128,1,'2017-03-11 20:05:43',4579.00000,'C','GBP',3),(129,3,'2017-03-11 20:05:43',4579.00000,'D','GBP',1);
/*!40000 ALTER TABLE `accounttransaction` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `asset_cash_statement`
--

LOCK TABLES `asset_cash_statement` WRITE;
/*!40000 ALTER TABLE `asset_cash_statement` DISABLE KEYS */;
INSERT INTO `asset_cash_statement` VALUES ('2017-02-15',9886.12),('2017-02-18',9886.12),('2017-02-22',9886.12),('2017-02-26',9886.12),('2017-02-27',9886.12),('2017-03-03',9886.12),('2017-03-06',9886.12),('2017-03-11',9886.12),('2017-03-13',9886.12);
/*!40000 ALTER TABLE `asset_cash_statement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset_cash_transactions`
--

DROP TABLE IF EXISTS `asset_cash_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_cash_transactions` (
  `Transaction_DateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Transaction_Amount` decimal(15,2) unsigned NOT NULL,
  `Transaction_ID` varchar(3) NOT NULL,
  PRIMARY KEY (`Transaction_DateTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_cash_transactions`
--

LOCK TABLES `asset_cash_transactions` WRITE;
/*!40000 ALTER TABLE `asset_cash_transactions` DISABLE KEYS */;
INSERT INTO `asset_cash_transactions` VALUES ('2017-02-10 05:32:53',50000.00,'D'),('2017-02-10 15:32:04',43377.00,'C'),('2017-02-13 11:27:19',29193.88,'D'),('2017-02-13 13:11:46',9534.00,'C'),('2017-02-15 13:27:43',14603.24,'D'),('2017-02-15 13:39:59',31000.00,'C');
/*!40000 ALTER TABLE `asset_cash_transactions` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `asset_share_statement`
--

LOCK TABLES `asset_share_statement` WRITE;
/*!40000 ALTER TABLE `asset_share_statement` DISABLE KEYS */;
INSERT INTO `asset_share_statement` VALUES ('2017-02-10',43377.00),('2017-02-11',43377.00),('2017-02-12',43377.00),('2017-02-15',40780.00),('2017-02-16',40930.00),('2017-02-18',41202.00),('2017-02-22',40946.00),('2017-02-25',40762.00),('2017-02-26',40762.00),('2017-02-27',40762.00),('2017-03-03',40760.00),('2017-03-06',40760.00),('2017-03-13',40276.00);
/*!40000 ALTER TABLE `asset_share_statement` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `asset_share_transaction`
--

LOCK TABLES `asset_share_transaction` WRITE;
/*!40000 ALTER TABLE `asset_share_transaction` DISABLE KEYS */;
INSERT INTO `asset_share_transaction` VALUES (1,'^FTSE',7229.50,'2017-02-10 15:32:04',6,'D'),(2,'^FTSE',7298.47,'2017-02-13 11:27:19',4,'C'),(3,'ECM',476.70,'2017-02-13 13:11:46',20,'D'),(4,'^FTSE',7301.62,'2017-02-15 13:27:43',2,'C'),(5,'LSE',3100.00,'2017-02-15 13:39:59',10,'D');
/*!40000 ALTER TABLE `asset_share_transaction` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `nav_value`
--

LOCK TABLES `nav_value` WRITE;
/*!40000 ALTER TABLE `nav_value` DISABLE KEYS */;
INSERT INTO `nav_value` VALUES ('2017-02-10',1.000000),('2017-02-12',1.000000),('2017-02-13',1.000000),('2017-02-14',1.000000),('2017-02-15',0.986853),('2017-02-16',0.983940),('2017-02-21',0.983630),('2017-02-22',0.983630),('2017-02-25',0.987203),('2017-02-26',0.987203),('2017-02-27',0.987203),('2017-03-01',0.987242),('2017-03-03',0.987242),('2017-03-04',0.987242),('2017-03-05',0.987242),('2017-03-06',0.987242),('2017-03-11',0.987242),('2017-03-13',0.987242);
/*!40000 ALTER TABLE `nav_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'stockchain'
--
/*!50003 DROP PROCEDURE IF EXISTS `getAccountTransactions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccountTransactions`(IN inputUsername varchar(50))
begin
select ifnull((select username from stockchain.accountauth where Account_ID = Counterparty_ID), "StockChain") as Counterparty, Transaction_Amount, Transaction_DateTime, Transaction_Code, Transaction_Currency, CASE Transaction_Currency WHEN "GBP" THEN Transaction_Amount * Quote WHEN "Stock" THEN Transaction_Amount END AS Stock_Equivalent
FROM stockchain.accounttransaction
join stockchain.nav_value
on date(if(time(Transaction_DateTime) < "16:40:00", date_sub(Transaction_DateTime, interval 1 day), Transaction_DateTime)) = nav_value.Quote_Date
where Account_ID = (select Account_ID from stockchain.accountauth where username = inputUsername);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_account_balance`(IN inputUsername VARCHAR(50))
BEGIN

# Stock held by account * £ per stock. Relies on daily updated nav_value.
SELECT 
    ((Closing_Balance + IFNULL(Account_Change, 0)) / (SELECT quote
													  FROM stockchain.nav_value
													  ORDER BY Quote_Date DESC
                                                      LIMIT 1)) AS balance
FROM
	# Previous statement stock determination
    (SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT Closing_Balance * Quote AS Closing_Balance
		 FROM stockchain.accountstatement
		 JOIN stockchain.nav_value 
         ON DATE(stockchain.accountstatement.Statement_Date) = stockchain.nav_value.Quote_Date
		 WHERE Statement_Date = (SELECT MAX(stockchain.accountstatement.Statement_Date)
		 						 FROM stockchain.accountstatement
								 WHERE Account_ID = (SELECT Account_ID
													 FROM stockchain.accountauth
													 WHERE username = inputUsername)
								)
		 AND Account_ID = (SELECT Account_ID
						   FROM stockchain.accountauth
						   WHERE username = inputUsername)
		 ) AS another_table
	) AS previous_statement
    
JOIN

	# Stock contribution of transactions from first of the month to current time.
    (SELECT SUM((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) AS Account_Change
	 FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM stockchain.accounttransaction
		 JOIN stockchain.nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00', DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY), Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(NOW(), '%Y-%m-01') AND NOW()
		 AND Account_ID = (SELECT Account_ID
						   FROM accountauth
						   WHERE username = inputUsername)
		) AS Transactions
	) AS table2 
ON Account_Change;

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_account_stock_balance`(IN inputUsername VARCHAR(50))
BEGIN

# Stock held by account
SELECT (Closing_Balance + IFNULL(Account_Change, 0)) as balance
FROM
	# Previous statement stock determination
    (SELECT IFNULL(Closing_Balance, 0) AS Closing_Balance
     FROM
        (SELECT Closing_Balance * Quote AS Closing_Balance
		 FROM stockchain.accountstatement
		 JOIN stockchain.nav_value 
         ON DATE(stockchain.accountstatement.Statement_Date) = stockchain.nav_value.Quote_Date
		 WHERE Statement_Date = (SELECT MAX(stockchain.accountstatement.Statement_Date)
		 						 FROM stockchain.accountstatement
								 WHERE Account_ID = (SELECT Account_ID
													 FROM stockchain.accountauth
													 WHERE username = inputUsername)
								)
		 AND Account_ID = (SELECT Account_ID
						   FROM stockchain.accountauth
						   WHERE username = inputUsername)
		 ) AS another_table
	) AS previous_statement
    
LEFT JOIN

	# Stock contribution of transactions from first of the month to current time.
    (SELECT SUM((CASE Transactions.Transaction_Code
			 WHEN 'C' THEN Transactions.Transaction_Amount * Transactions.Quote
			 WHEN 'D' THEN - Transactions.Transaction_Amount * Transactions.Quote END)) AS Account_Change
	 FROM
        (SELECT Account_ID, Transaction_Amount, Transaction_Code, Quote
		 FROM stockchain.accounttransaction
		 JOIN stockchain.nav_value 
         ON DATE(IF(TIME(Transaction_DateTime) < '16:40:00', DATE_SUB(Transaction_DateTime, INTERVAL 1 DAY), Transaction_DateTime)) = nav_value.Quote_Date
		 WHERE Transaction_DateTime BETWEEN DATE_FORMAT(NOW(), '%Y-%m-01') AND NOW()
		 AND Account_ID = (SELECT Account_ID
						   FROM accountauth
						   WHERE username = inputUsername)
		) AS Transactions
	) AS table2 
ON Account_Change;

END ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_owned_stocks`()
BEGIN

select stockchain.asset_share_transaction.Ticker_Symbol, SUM(CASE stockchain.asset_share_transaction.Transaction_Code 
	WHEN "D" THEN stockchain.asset_share_transaction.Transaction_Amount 
    WHEN "C" THEN -stockchain.asset_share_transaction.Transaction_Amount END) AS Amount
from stockchain.asset_share_transaction
group by stockchain.asset_share_transaction.Ticker_Symbol;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `makeTransaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `makeTransaction`(IN fromUser VARCHAR(50), toUser VARCHAR(50), amount decimal(15,5))
begin
set @current_datetime = NOW();
insert into stockchain.accounttransaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) VALUES ((SELECT Account_ID from stockchain.accountauth where username = toUser), @current_datetime, amount, "C", "GBP", (SELECT Account_ID from stockchain.accountauth where username = fromUser));
insert into stockchain.accounttransaction (Account_ID, Transaction_Datetime, Transaction_Amount, Transaction_Code, Transaction_Currency, Counterparty_ID) VALUES ((SELECT Account_ID from stockchain.accountauth where username = fromUser), @current_datetime, amount, "D", "GBP", (SELECT Account_ID from stockchain.accountauth where username = toUser));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateaccountstatements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateaccountstatements`(IN NewStatementDate date, PreviousStatementDate date)
BEGIN
insert into stockchain.accountstatement 
select CarriedForwardBalance.Account_ID, CarriedForwardBalance.Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0) AS Closing_Balance 
from (select stockchain.accountauth.Account_ID, NewStatementDate AS Statement_Date, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance from stockchain.accountauth
LEFT JOIN
(SELECT * FROM stockchain.accountstatement
WHERE Statement_Date = PreviousStatementDate) AS MostRecentStatements
ON stockchain.accountauth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN 
(Select Account_ID, SUM(CASE Transactions.Transaction_Code WHEN "C" THEN Transactions.Transaction_Amount WHEN "D" THEN -Transactions.Transaction_Amount END) AS Account_Change FROM
(SELECT Account_ID, Transaction_Amount, Transaction_Code 
FROM stockchain.accounttransaction
WHERE Transaction_DateTime between PreviousStatementDate and NewStatementDate)
AS Transactions
group by Transactions.Account_ID) AS TransactionsTotal
ON CarriedForwardBalance.Account_ID = TransactionsTotal.Account_ID;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_account_statement`()
BEGIN
insert into stockchain.accountstatement
select CarriedForwardBalance.Account_ID, CarriedForwardBalance.Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(Transactions.Account_Change, 0) AS Closing_Balance 
from 
	(select stockchain.accountauth.Account_ID,  DATE_FORMAT(now(),'%Y-%m-01') AS Statement_Date, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance 
	from stockchain.accountauth
		LEFT JOIN
		(SELECT * 
        FROM stockchain.accountstatement
		WHERE Statement_Date = DATE_FORMAT(date_sub(now(), interval 1 month) ,'%Y-%m-01')) AS MostRecentStatements
		ON stockchain.accountauth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN 
(Select Account_ID, DATE_FORMAT(now(),'%Y-%m-01') as Statement_Date, ((1/Quote) * Account_Change) as Account_Change
from
	(Select Account_ID, SUM(CASE Transactions.Transaction_Code WHEN "C" THEN Transactions.Transaction_Amount * Transactions.Quote WHEN "D" 
		THEN -Transactions.Transaction_Amount * Transactions.Quote END) AS Account_Change 
		FROM
			(SELECT Transaction_Amount, Transaction_Code, Quote, Account_ID
			FROM 
				stockchain.accounttransaction
				join stockchain.nav_value
				on date(if(time(Transaction_DateTime) < "16:40:00", date_sub(Transaction_DateTime, interval 1 day), Transaction_DateTime)) = nav_value.Quote_Date
				WHERE Transaction_DateTime between DATE_FORMAT(date_sub(now(), interval 1 month) ,'%Y-%m-01') AND DATE_FORMAT(now(),'%Y-%m-01')
			) AS Transactions 
		group by Account_ID) as account_change
	join stockchain.nav_value
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_cash_statement`()
BEGIN

insert into stockchain.asset_cash_statement 
values(curdate(), (select SUM(CASE stockchain.asset_cash_transactions.Transaction_ID 
	WHEN "D" THEN stockchain.asset_cash_transactions.Transaction_Amount 
    WHEN "C" THEN -stockchain.asset_cash_transactions.Transaction_Amount END) from stockchain.asset_cash_transactions));

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_nav_value`()
BEGIN

insert into stockchain.nav_value
select curdate(), 1/(((select stockchain.asset_share_statement.Closing_Balance from stockchain.asset_share_statement order by stockchain.asset_share_statement.Statement_Date desc limit 1) + 
	(select stockchain.asset_cash_statement.Closing_Balance from stockchain.asset_cash_statement order by stockchain.asset_cash_statement.Statement_Date desc limit 1))/(select SUM(stockchain.accounttransaction.Transaction_Amount * Quote) 
from stockchain.accounttransaction
join stockchain.nav_value
on Date(stockchain.accounttransaction.Transaction_DateTime) = Quote_Date
where stockchain.accounttransaction.Counterparty_ID = 0));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_share_statement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_share_statement`(IN NewStatementDate date, PreviousStatementDate date)
BEGIN
insert into stockchain.asset_share_statement 
select "2017-02-11" AS Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0)
AS Closing_Balance from

	# Previous statement determination 
	(select ifnull((select Closing_Balance 
	FROM stockchain.asset_share_statement
	WHERE Statement_Date = (select MAX(stockchain.asset_share_statement.Statement_Date) from stockchain.asset_share_statement)
    limit 1), 0) AS Closing_Balance)
	AS CarriedForwardBalance

	cross join

	# New transactions determination
	(Select SUM(CASE Transactions.Transaction_Code WHEN "D" THEN Transactions.Transaction_Amount * Transactions.Share_Price 
	WHEN "C" THEN -(Transactions.Transaction_Amount * Transactions.Share_Price) END) AS Account_Change FROM
		(SELECT Transaction_Amount, Transaction_Code, Share_Price
		FROM stockchain.asset_share_transaction
		WHERE Transaction_DateTime between DATE_SUB("2017-02-11 16:35", INTERVAL 0.5 day) AND NOW())
		AS Transactions) 
	AS TransactionsTotal;

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

-- Dump completed on 2017-03-14 17:14:36
