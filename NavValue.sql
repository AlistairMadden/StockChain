drop table nav_value;

CREATE table nav_value(
	Quote_Date Date NOT NULL,
	Quote decimal(8, 6) unsigned NOT NULL,
	PRIMARY KEY(Quote_Date));