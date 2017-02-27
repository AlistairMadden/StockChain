drop table asset_share_transaction;

CREATE table asset_share_transaction(
	Trade_ID int unsigned not null auto_increment,
    Ticker_Symbol varchar(5) not null,
    Share_Price decimal(8,2) not null,
	Transaction_DateTime datetime NOT NULL,
	Transaction_Amount int UNSIGNED NOT NULL,
	Transaction_Code VARCHAR(3) NOT NULL,
	PRIMARY KEY(Trade_ID));