CREATE table asset_cash_transactions(
	Transaction_DateTime TIMESTAMP NOT NULL,
	Transaction_Amount FLOAT UNSIGNED NOT NULL,
	Transaction_ID VARCHAR(3) NOT NULL,
	PRIMARY KEY(Transaction_DateTime))