CREATE table accountAuth(
	Account_ID INT UNSIGNED NOT NULL auto_increment,
    UNIQUE username VARCHAR(50) not null,
    password CHAR(60) not null,
    primary key(Account_ID))