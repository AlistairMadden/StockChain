DROP TABLE IF EXISTS `asset_share_transaction`;

CREATE table asset_share_transaction(
	Trade_ID int unsigned not null auto_increment,
    Ticker_Symbol varchar(5) not null,
    Share_Price decimal(8,2) not null,
	Transaction_DateTime timestamp not null,
	Transaction_Amount int unsigned not null,
	Transaction_Code varchar(3) not null,
	PRIMARY KEY(Trade_ID));