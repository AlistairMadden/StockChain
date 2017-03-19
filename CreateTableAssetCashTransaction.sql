DROP TABLE IF EXISTS `asset_cash_transaction`;

CREATE table asset_cash_transaction(
	Transaction_ID int unsigned auto_increment NOT NULL,
	Transaction_DateTime TIMESTAMP NOT NULL,
	Transaction_Amount decimal(15,2) not null,
    Transaction_Code varchar(3) not null,
	PRIMARY KEY(Transaction_ID))