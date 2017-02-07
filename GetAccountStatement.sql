DELIMITER $$
create procedure getAccountStatement(IN inputUsername VARCHAR(50)) 
BEGIN
select CarriedForwardBalance.account_id, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0) AS balance 
from (select stockchain.accountauth.Account_ID, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance from stockchain.accountauth
LEFT JOIN
(SELECT * FROM stockchain.accountstatement where Statement_Date =(select MAX(stockchain.accountstatement.Statement_Date) from stockchain.accountstatement)) AS MostRecentStatements
ON stockchain.accountauth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN 
(Select Account_ID, SUM(CASE Transactions.Transaction_ID WHEN "C" THEN Transactions.Transaction_Amount WHEN "D" THEN -Transactions.Transaction_Amount END) AS Account_Change FROM
(SELECT Account_ID, Transaction_Amount, Transaction_ID 
FROM stockchain.accounttransaction
WHERE Transaction_DateTime between (Select MAX(Statement_Date) from stockchain.accountstatement) and NOW())
AS Transactions
group by Transactions.Account_ID) AS TransactionsTotal
ON CarriedForwardBalance.Account_ID = TransactionsTotal.Account_ID
where CarriedForwardBalance.Account_ID = (SELECT Account_ID from stockchain.accountauth where username = inputUsername);
END $$
DELIMITER ;