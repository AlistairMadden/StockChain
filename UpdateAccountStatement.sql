DELIMITER $$
create procedure updateaccountstatements(IN NewStatementDate date, PreviousStatementDate date) 
BEGIN
insert into stockchain.accountstatement 
select CarriedForwardBalance.Account_ID, CarriedForwardBalance.Statement_Date, CarriedForwardBalance.Closing_Balance + IFNULL(TransactionsTotal.Account_Change, 0) AS Closing_Balance 
from (select stockchain.accountauth.Account_ID, NewStatementDate AS Statement_Date, IFNULL(MostRecentStatements.Closing_Balance, 0) AS Closing_Balance from stockchain.accountauth
LEFT JOIN
(SELECT * FROM stockchain.accountstatement
WHERE Statement_Date = PreviousStatementDate) AS MostRecentStatements
ON stockchain.accountauth.Account_ID = MostRecentStatements.Account_ID) AS CarriedForwardBalance
LEFT JOIN 
(Select Account_ID, SUM(CASE Transactions.Transaction_ID WHEN "C" THEN Transactions.Transaction_Amount WHEN "D" THEN -Transactions.Transaction_Amount END) AS Account_Change FROM
(SELECT Account_ID, Transaction_Amount, Transaction_ID 
FROM stockchain.accounttransaction
WHERE Transaction_DateTime between PreviousStatementDate and NewStatementDate)
AS Transactions
group by Transactions.Account_ID) AS TransactionsTotal
ON CarriedForwardBalance.Account_ID = TransactionsTotal.Account_ID;
END $$
DELIMITER ;