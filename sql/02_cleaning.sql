SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(loan_status) AS missing_loan_status,
    COUNT(*) - COUNT(grade) AS missing_grade,
    COUNT(*) - COUNT(dti) AS missing_dti,
    COUNT(*) - COUNT(emp_length) AS missing_emp_length,
    COUNT(*) - COUNT(annual_inc) AS missing_annual_inc
FROM loans_raw;

SELECT issue_d FROM loans_raw LIMIT 5;

SELECT DISTINCT issue_d FROM loans_raw ORDER BY issue_d LIMIT 10;

SELECT
    issue_d,
    TO_DATE(issue_d, 'Mon-YYYY') AS issue_date_parsed
FROM loans_raw
ORDER BY issue_d
LIMIT 10;

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
    addr_state
FROM loans_raw
WHERE
    loan_status IN ('Fully Paid', 'Charged Off', 'Default')
    AND TO_DATE(issue_d, 'Mon-YYYY') BETWEEN '2016-01-01' AND '2018-12-31'
    AND dti IS NOT NULL
    AND annual_inc IS NOT NULL;

    SELECT COUNT(*) FROM loans_clean;

SELECT
    MIN(issue_date) AS earliest_loan,
    MAX(issue_date) AS latest_loan,
    COUNT(DISTINCT loan_status) AS distinct_statuses
FROM loans_clean;