DELIMITER $$
create procedure makeTransaction(IN fromUser VARCHAR(50), toUser VARCHAR(50), amount int)
begin
declare current_datetime timestamp default NOW();
insert into stockchain.accounttransaction VALUES ((SELECT Account_ID from stockchain.accountauth where username = toUser), current_datetime, amount, "C", (SELECT Account_ID from stockchain.accountauth where username = fromUser));
insert into stockchain.accounttransaction VALUES ((SELECT Account_ID from stockchain.accountauth where username = fromUser), current_datetime, amount, "D", (SELECT Account_ID from stockchain.accountauth where username = fromUser));
end$$
DELIMITER ;