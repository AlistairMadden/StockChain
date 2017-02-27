drop table accountstatement;

CREATE table AccountStatement(
	Account_ID INT UNSIGNED NOT NULL,
    Statement_Date DATE not null,
    Closing_Balance decimal(15,5) unsigned not null,
    primary key(Account_ID, Statement_Date))