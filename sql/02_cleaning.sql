-- ============================================================
-- Data Cleaning
--
-- Builds loans_clean from loans_raw: filters to loans issued
-- 2016-2018 with a resolved outcome (Fully Paid, Charged Off,
-- or Default), converts issue_d to a real date, and removes
-- rows missing core risk metrics (dti, annual_inc). Scope
-- decisions here directly implement docs/00_problem_statement.md.
-- ============================================================

-- Check for missing values in key analysis columns before cleaning
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(loan_status) AS missing_loan_status,
    COUNT(*) - COUNT(grade) AS missing_grade,
    COUNT(*) - COUNT(dti) AS missing_dti,
    COUNT(*) - COUNT(emp_length) AS missing_emp_length,
    COUNT(*) - COUNT(annual_inc) AS missing_annual_inc
FROM loans_raw;

SELECT issue_d FROM loans_raw LIMIT 5;

-- Confirm issue_d's text format (Mon-YYYY) is consistent across
-- the dataset before converting it to a real date type
SELECT DISTINCT issue_d FROM loans_raw ORDER BY issue_d LIMIT 10;

-- Test the TO_DATE conversion before using it in the final table
SELECT
    issue_d,
    TO_DATE(issue_d, 'Mon-YYYY') AS issue_date_parsed
FROM loans_raw
ORDER BY issue_d
LIMIT 10;

-- Build the cleaned, scoped table. loans_raw is left untouched;
-- loans_clean is fully rebuildable from this query at any time.
CREATE TABLE loans_clean AS
SELECT
    id,
    loan_amnt,
    funded_amnt,
    term,
    int_rate,
    installment,
    grade,
    sub_grade,
    emp_length,
    home_ownership,
    annual_inc,
    verification_status,
    TO_DATE(issue_d, 'Mon-YYYY') AS issue_date,
    loan_status,
    purpose,
    dti,
    addr_state,
    total_pymnt,
    total_rec_int,
    total_rec_prncp,
    out_prncp
FROM loans_raw
WHERE
    loan_status IN ('Fully Paid', 'Charged Off', 'Default')
    AND TO_DATE(issue_d, 'Mon-YYYY') BETWEEN '2016-01-01' AND '2018-12-31'
    AND dti IS NOT NULL
    AND annual_inc IS NOT NULL;

-- Verify the result
SELECT COUNT(*) FROM loans_clean;

SELECT
    MIN(issue_date) AS earliest_loan,
    MAX(issue_date) AS latest_loan,
    COUNT(DISTINCT loan_status) AS distinct_statuses
FROM loans_clean;

SELECT COUNT(*) 
FROM information_schema.columns 
WHERE table_name = 'loans_raw';