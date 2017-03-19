DROP TABLE IF EXISTS `asset_share_statement`;

CREATE table asset_share_statement(
	Account_ID int unsigned not null,
    Statement_Date date not null,
    Closing_Balance decimal(15,2) not null,
    primary key(Statement_Date));