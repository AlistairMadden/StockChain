CREATE table AccountTransaction(
	Account_ID INT UNSIGNED NOT NULL,
	Transaction_DateTime TIMESTAMP NOT NULL,
	Transaction_Amount FLOAT UNSIGNED NOT NULL,
	Transaction_ID VARCHAR(3) NOT NULL,
    Counterparty_ID INT unsigned not null,
	PRIMARY KEY(Account_ID, Transaction_DateTime, Counterparty_ID))