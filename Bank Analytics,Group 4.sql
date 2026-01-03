Create Database Bank_Analytics;
use  bank_Analytics;
select * from bank_data;
-- 1.Total Loan Amount Funded
SELECT Concat(ROUND(SUM(`Funded Amount`)/1000000,2)," M") AS total_loan_amount_funded from bank_data;
-- 2.Total Loans
SELECT Concat(ROUND(count('Account id')/1000,2)," K") AS total_loans from bank_data;
-- 3. Total Collection
SELECT CONCAT(Round(SUM(`Total Rec Prncp`)/1000000 + SUM(`Total Rrec int`)/1000000 + SUM(`Total Fees`)/1000000,2)," M") AS `Total Collection`FROM bank_data;
-- 4. Total Interest
Select CONCAT(ROUND(SUM(`Total Rrec int`)/1000000,2)," M") as Total_interest from bank_data;
-- 5.Branch wise Performance
select `Branch Name`,CONCAT(ROUND(Sum(`Total Rrec int`)/1000000+SUM(`Total Fees`)/1000000,2)," M") as total_revenue from bank_data group by `Branch Name` order by total_revenue desc;
-- 6. State-Wise Loan
select `ï»¿State Abbr`,ROUND(CONCAT(SUM(`Loan Amount`)/1000000," M"),1) as Loan_Amount from bank_data where `ï»¿State Abbr`!="State Name" group by `ï»¿State Abbr` order by loan_Amount desc;
-- 7.Religion wise Loan
select religion,ROUND(CONCAT(sum(`Loan Amount`)/1000000," M"),2) as Loan_Amount from bank_data where religion in ('Christian','Hindu','Muslim','Sikh') group by religion order by Loan_Amount desc;
-- 8. Product Group Wise Loan
select `product code`,CONCAT(ROUND((sum(`Loan Amount`)/1000000),1)," M") as Loan_Amount from bank_data group by `product code` order by Loan_Amount desc;
-- 9.Disbursement Trend
select 
Right(`Disbursement Date`,4) as year,
mid(`Disbursement Date`,4,2) as month,
Left(`Disbursement Date`,2) as day,
SUM(`Funded Amount`) over (partition by Right(`Disbursement Date`,4),mid(`Disbursement Date`,4,2),Left(`Disbursement Date`,2)) as 'Funded Amount'
from bank_data;
-- 10.Grade-Wise Loan
with cte as (select grrade,CONCAT(ROUND(sum(`Loan Amount`)/1000000,2)," M") as Loan_Amount from bank_data group by grrade )
select * from cte order by loan_amount desc;
-- 11.Default Loan Count
select count(`Account ID`)  as Loan_Count from bank_data where `is Default Loan` ='Y';
-- 12.Delinquent Client Count
select distinct COUNT(`Client name`) as deliquent_Client from bank_data 
where `Is Delinquent Loan`='Y';
-- 13.Deliquent Loan Rate
 SELECT 
    Concat(COUNT(`Client name`) * 100.0 / (Select COUNT(*) from bank_data),'%') AS delinquent_client_percentage
FROM bank_data
WHERE `Is Delinquent Loan` = 'Y';
-- 14.Default Loan Rate
select CONCAT(SUM(case 
when `is default loan`='Y' then 1
else 0
end) *100
/count(*),' %') as 'deliquent_Client_Percentage' from bank_data;
-- 15. Loan status wise Loan
create view myview as select `loan status`,Concat(Round(sum(`loan Amount`)/1000000,2)," M") as loan_Amount from bank_data group by `loan status`;
select *,row_number() over(order by `loan status`) as Rnk from myview;
