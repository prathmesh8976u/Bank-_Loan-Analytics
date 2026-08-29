-- KPI


-- 1. Total Loan Amount
SELECT 
ROUND(SUM(loan_amnt)/1000000,2) AS total_loan_million
FROM finance_full;


-- 2. Total Loan Count
SELECT 
COUNT(*) AS total_loans
FROM finance_full;


-- 3. Average Interest Rate
SELECT 
ROUND(AVG(int_rate),2) AS avg_interest_rate
FROM finance_full;


-- 4. Average Loan Amount
SELECT 
ROUND(AVG(loan_amnt),2) AS avg_loan_amount
FROM finance_full;


-- 5. Total Payment Received
SELECT 
ROUND(SUM(total_payment)/1000000,2) AS total_payment_million
FROM finance_full;


-- 6. Loan Status
 SELECT 
    loan_status,
   ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM finance_full),2) AS percentage
FROM finance_full
GROUP BY loan_status;


-- 7.  Default Rate
SELECT 
ROUND(SUM(
CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS default_rate
FROM finance_full;


-- 8. Bad Loan Amount
SELECT 
ROUND(SUM(loan_amnt)/1000000,2) AS total_loan_million,
ROUND(SUM(CASE WHEN loan_status='Charged Off' THEN loan_amnt END)/1000000,2) AS bad_loan_million
FROM finance_full;


-- 9. Recovery Rate
SELECT 
ROUND(
    SUM(recoveries) * 100 / 
    SUM(CASE WHEN loan_status='Charged Off' THEN loan_amnt END),
2) AS recovery_rate
FROM finance_full;


-- 10.  Year-wise Loan Amount Stats
SELECT 
    YEAR(issue_date) AS year,
    round(SUM(loan_amnt)/1000000,2) 
    AS total_loan_million
FROM finance_full
GROUP BY YEAR(issue_date)
ORDER BY year;


-- 11. Monthly Trend
SELECT 
    MONTHNAME(issue_date) AS month,
    COUNT(*) AS total_loans
FROM finance_full
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);


-- 12. Top 10 States
SELECT state, COUNT(*) AS total_loans
FROM finance_full
GROUP BY state
ORDER BY total_loans DESC
LIMIT 10;


-- 13.  State & Month-wise Loan Status
SELECT 
    state,
    MONTHNAME(issue_date) AS month,
    COUNT(CASE WHEN loan_status='Fully Paid' THEN 1 END) AS fully_paid,
    COUNT(CASE WHEN loan_status='Charged Off' THEN 1 END) AS charged_off
FROM finance_full
GROUP BY state, MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY FULLY_PAID DESC
limit 10;


-- 14. Default Rate by Grade
SELECT 
    customer_grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
    2) AS default_rate
FROM finance_full
GROUP BY customer_grade
ORDER BY default_rate DESC;


-- 16. Average Loan vs Income by Customer Grade
SELECT 
    customer_grade,
    round(avg(loan_amnt)/1000,2) as Avg_Loan_Amnt_Thousand,
    round(AVG(Annual_income)/1000,2) as Avg_Annual_Income_Thousand
FROM finance_full
GROUP BY customer_grade
order by avg(loan_amnt) desc;


-- 17. Debt-to-Income Risk
SELECT 
round(AVG(debt_to_income_ratio),2) AS avg_dti_ratio,
loan_status
FROM finance_full
GROUP BY loan_status;


-- 18. Interest Category Analysis
SELECT 
    CASE 
        WHEN int_rate > 15 THEN 'High'
        WHEN int_rate BETWEEN 10 AND 15 THEN 'Medium'
        ELSE 'Low'
    END AS interest_category,
    
    COUNT(*) AS total_loans,
    
    SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) AS defaults

FROM finance_full
GROUP BY interest_category;


-- 19. Verified vs Non-Verified Payment
SELECT 
    verification_status,
   round(SUM(Total_Payment)/1000000,2) 
   AS total_payment_million,
   round(COUNT(*)/1000,2) AS total_customers_thousand
FROM finance_full
GROUP BY verification_status
order by total_payment_million desc;


-- 20.  Grade & Sub-grade wise Revolving Balance
SELECT 
    customer_grade,
    customer_sub_grade,
    round(SUM(Revolving_Balance)/1000000,2) AS total_revol_bal_million,
   round(AVG(Revolving_Balance)/1000,2)AS avg_revol_bal_thousand
FROM finance_full
GROUP BY customer_grade, customer_sub_grade
ORDER BY SUM(Revolving_Balance) desc 
limit 10;


-- 21.  Good vs Bad Loan
SELECT 
    CASE 
        WHEN loan_status='Fully Paid' 
        THEN 'Good Loan'
        ELSE 'Bad Loan'
    END AS loan_type,
    COUNT(*) 
FROM finance_full
GROUP BY loan_type;


-- 22. Home Ownership vs Last Payment Date
SELECT 
    Home_Ownership,
    MAX(Last_Payment_Date) AS last_payment,
    COUNT(*) AS total_loans_count,
    ROUND(SUM(loan_amnt)/1000000,2) AS total_amount_million
FROM finance_full
GROUP BY Home_Ownership
ORDER BY last_payment DESC;
