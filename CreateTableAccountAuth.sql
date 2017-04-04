DROP TABLE IF EXISTS `account_auth`;

CREATE table account_auth(
	Account_ID INT UNSIGNED NOT NULL auto_increment,
    Username VARCHAR(254) not null,
    Password_Hash CHAR(60) not null,
    Openchain_Key CHAR(111) not null,
    unique(username),
    primary key(Account_ID))