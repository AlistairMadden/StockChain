CREATE table AccountStatement(
	Account_ID INT UNSIGNED NOT NULL auto_increment,
    Statement_Date TIMESTAMP not null,
    Closing_Balance float not null,
    primary key(Account_ID, Statement_Date))