DROP TABLE IF EXISTS `nav_value`;

CREATE table nav_value(
	Quote_Date date not null,
	Quote decimal(8, 6) unsigned not null,
	PRIMARY KEY(Quote_Date));