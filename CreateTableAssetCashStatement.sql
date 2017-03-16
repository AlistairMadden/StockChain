DROP TABLE IF EXISTS `asset_cash_statement`;

CREATE table asset_cash_statement(
	Account_ID INT UNSIGNED NOT NULL,
    Statement_Date DATE not null,
    Closing_Balance decimal(15,2) not null,
    primary key(Account_ID, Statement_Date))