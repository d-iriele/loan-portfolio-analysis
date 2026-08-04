SELECT COUNT(*) FROM loans_raw;

-- ==========================================================
-- Business Question 1: Which borrower segments generate the 
-- highest default risk?
-- ==========================================================

-- Default rate by loan grade
SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM loans_clean
GROUP BY grade
ORDER BY default_rate_pct DESC;

-- Finding: Default rate rises sharply and consistently from grade A (6.83%)
-- to grade G (53.56%) — nearly an 8x difference. This confirms Lending
-- Club's assigned grade is a strong, reliable risk signal on its own.

-- Default rate by loan purpose
SELECT
    purpose,
    COUNT(*) AS total_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM loans_clean
GROUP BY purpose
ORDER BY default_rate_pct DESC;

-- Finding: Small business loans show the highest default rate among
-- meaningfully-sized segments (34.53%, n=5,581) — nearly double the rate
-- for car loans (16.49%). Wedding (33.33%) is excluded from serious
-- consideration due to an extremely small sample (n=3).

-- Default rate by home ownership status
SELECT
    home_ownership,
    COUNT(*) AS total_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM loans_clean
GROUP BY home_ownership
ORDER BY default_rate_pct DESC;

-- Finding: Renters show the highest default rate (27.17%) compared to
-- homeowners with a mortgage (18.67%) — nearly a 9-point gap, suggesting
-- housing stability is meaningfully correlated with repayment risk.
-- ANY/NONE categories are ignored due to negligible sample sizes.


-- ================================================================
-- Business Question 2: Which loan characteristics predict default 
-- beyond grade alone?
-- ================================================================

-- Default rate by loan term
SELECT
    term,
    COUNT(*) AS total_loans,
    ROUND(AVG(int_rate), 2) AS avg_interest_rate,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM loans_clean
GROUP BY term
ORDER BY default_rate_pct DESC;

-- Finding: 60-month loans default at nearly double the rate of 36-month
-- loans (33.45% vs. 19.23%). Part of this gap is explained by pricing —
-- 60-month loans carry a higher average interest rate (17.23% vs. 12.28%)
-- but the default rate gap is proportionally larger than the rate gap,
-- suggesting term length itself carries additional risk signal beyond
-- what's already priced in.

-- Average DTI and interest rate: defaulted vs. non-defaulted loans
SELECT
    CASE
        WHEN loan_status IN ('Charged Off', 'Default') THEN 'Defaulted'
        ELSE 'Fully Paid'
    END AS outcome,
    COUNT(*) AS total_loans,
    ROUND(AVG(dti), 2) AS avg_dti,
    ROUND(AVG(int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(installment), 2) AS avg_installment
FROM loans_clean
GROUP BY outcome;

-- Finding: Defaulted loans show meaningfully higher average DTI (20.60
-- vs. 18.25) and interest rate (16.03% vs. 12.63%) than fully-paid loans.
-- The interest rate difference insight is partly circular since interest rate is already 
-- largely determined by grade, so "defaulted loans have higher interest rates" 
-- partially just re-confirms "defaulted loans have worse grades," whihch we established in question 1.
-- Nevertheless this confirms both factors carry real predictive signal beyond grade
-- alone, supporting the case for incorporating DTI more directly into
-- underwriting decisions rather than relying on grade as a single proxy.


-- ============================================================
-- BUSINESS QUESTION 3: How has portfolio risk changed over time?
-- (Vintage Analysis by Issue Year)
-- ============================================================

SELECT
    EXTRACT(YEAR FROM issue_date) AS issue_year,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(dti), 2) AS avg_dti,
    ROUND(AVG(int_rate), 2) AS avg_interest_rate,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM loans_clean
GROUP BY issue_year
ORDER BY issue_year;

-- Finding: Both loan volume and default rate decline sharply from 2016
-- to 2018 (293,067 loans at 23.28% default → 56,167 loans at 15.76%
-- default). This is very likely a time-censoring artifact rather than
-- genuine underwriting improvement: our loans_clean table only includes
-- loans with a RESOLVED outcome (Fully Paid, Charged Off, or Default).
-- 2018 loans have had far less time to reach a resolved outcome than
-- 2016 loans, so many 2018 loans that will eventually default are still
-- marked "Current" and were excluded from this table entirely — both
-- shrinking the 2018 sample and understating its true default rate.
-- DTI and interest rate stayed roughly flat across all three years
-- (~18.5-19% DTI, ~13-14% interest), suggesting underwriting standards
-- and pricing were largely stable — the volume/default pattern above
-- is a data artifact, not evidence of loosening or tightening standards.


SELECT total_pymnt, total_rec_int, total_rec_prncp, out_prncp
FROM loans_raw
LIMIT 5;

DROP TABLE loans_clean;

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

    SELECT COUNT(*) FROM loans_clean;