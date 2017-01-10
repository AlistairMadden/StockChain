CREATE table accountAuth(
	Account_ID INT UNSIGNED NOT NULL auto_increment,
    username VARCHAR(50) not null,
    password CHAR(60) not null,
    unique(username),
    primary key(Account_ID))