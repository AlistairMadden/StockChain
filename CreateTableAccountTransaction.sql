DROP TABLE IF EXISTS `account_transaction`;

CREATE table account_transaction(
	Transaction_ID INT UNSIGNED NOT NULL auto_increment,
	Account_ID INT UNSIGNED NOT NULL,
	Transaction_DateTime TIMESTAMP NOT NULL,
	Transaction_Amount decimal(15, 5) unsigned NOT NULL,
	Transaction_Code VARCHAR(3) NOT NULL,
    Transaction_Currency VARCHAR(3) not null,
    Counterparty_ID INT unsigned not null,
	PRIMARY KEY(Transaction_ID));