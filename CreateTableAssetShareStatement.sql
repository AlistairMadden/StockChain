drop table asset_share_statement;

CREATE table asset_share_statement(
    Statement_Date DATE not null,
    #ambitious
    Closing_Balance decimal(15,2) not null,
    primary key(Statement_Date));