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
-- to grade G (53.56%); nearly an 8x difference. This confirms Lending
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
-- meaningfully-sized segments (34.53%, n=5,581); nearly double the rate
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
-- homeowners with a mortgage (18.67%); close to a 9-point gap, suggesting
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
-- marked "Current" and were excluded from this table entirely - both
-- shrinking the 2018 sample and understating its true default rate.
-- DTI and interest rate stayed roughly flat across all three years
-- (~18.5-19% DTI, ~13-14% interest), suggesting underwriting standards
-- and pricing were largely stable and the volume/default pattern above
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


-- ============================================================
-- BUSINESS QUESTION 4: Which segments provide the poorest
-- risk-adjusted returns? (Interest Income vs. Realized Loss, by Grade)
--
-- Note: An earlier version of this query used out_prncp (outstanding
-- principal) as the loss measure, but Lending Club zeroes out
-- out_prncp once a loan is charged off making it unreliable for
-- exactly the loans that matter most. This version instead calculates
-- loss as funded_amnt - total_rec_prncp (amount lent minus amount
-- actually recovered), which correctly captures realized loss
-- regardless of loan outcome.
-- ============================================================

SELECT
    grade,
    COUNT(*) AS total_loans,
    ROUND(SUM(total_rec_int), 2) AS total_interest_income,
    ROUND(SUM(funded_amnt - total_rec_prncp), 2) AS total_realized_loss,
    ROUND(SUM(funded_amnt), 2) AS total_funded,
    ROUND(
        (SUM(total_rec_int) - SUM(funded_amnt - total_rec_prncp)) / SUM(funded_amnt) * 100,
        2
    ) AS risk_adjusted_return_pct
FROM loans_clean
GROUP BY grade
ORDER BY risk_adjusted_return_pct ASC;

-- Finding: Risk-adjusted return is negative for every grade except A
-- (1.77%). Returns decline steeply and consistently as risk increases:
-- B (-1.72%), C (-7.62%), D (-13.05%), E (-17.22%), F (-23.21%), and
-- G (-26.99%). This indicates that for grades B through G, the interest
-- charged did not come close to covering realized credit losses and the
-- portfolio was effectively losing money on the majority of its lending
-- activity when losses are properly accounted for. This directly
-- contradicts the assumption that higher interest rates on riskier
-- grades adequately compensate for their higher default risk; in this
-- portfolio, pricing was not steep enough to offset losses beyond
-- grade A.
--
-- Note: this is a TOTAL return over each loan's full life (3-5 years),
-- not an annualized rate so it should not be read as a yearly yield.


-- ============================================================
-- BUSINESS QUESTION 5: What is the potential financial impact of
-- targeted underwriting changes? (Scenario: Exclude Grades F & G)
-- ============================================================

SELECT
    CASE
        WHEN grade IN ('F', 'G') THEN 'Excluded (F & G)'
        ELSE 'Retained Portfolio'
    END AS scenario_segment,
    COUNT(*) AS total_loans,
    ROUND(SUM(funded_amnt), 2) AS total_funded,
    ROUND(SUM(total_rec_int), 2) AS total_interest_income,
    ROUND(SUM(funded_amnt - total_rec_prncp), 2) AS total_realized_loss,
    ROUND(
        (SUM(total_rec_int) - SUM(funded_amnt - total_rec_prncp)),
        2
    ) AS net_dollar_return
FROM loans_clean
GROUP BY scenario_segment;

-- Finding: Excluding grades F and G would have avoided $73.8M in net
-- losses (15,616 loans, ~3% of total loan count, ~4% of funded volume).
-- However, the remaining "retained" portfolio (grades A-E) still shows
-- a net dollar return of -$432.8M — consistent with Question 4's finding
-- that only grade A was individually profitable under this measure.
-- This indicates that excluding F/G alone is an incomplete fix: the
-- larger driver of portfolio-wide losses is grades B through E, which
-- represent far greater loan volume than F/G despite their comparatively
-- lower individual loss rates. A complete underwriting response should
-- prioritize re-pricing or tightening grades B-E, not just eliminating
-- the smaller F/G segment.
--
-- Note: figures represent total realized return over each loan's full
-- life (up to 5 years), not an annualized figure, and total_rec_int
-- reflects only interest collected to date — for loans still very early
-- in repayment at data capture, this may understate eventual income.

-- Supplementary: what average interest rate would grade G have needed
-- to break even (net_dollar_return = 0), holding loss constant?
SELECT
    grade,
    ROUND(SUM(funded_amnt - total_rec_prncp), 2) AS total_loss,
    ROUND(SUM(funded_amnt), 2) AS total_funded,
    ROUND(AVG(int_rate), 2) AS actual_avg_rate,
    ROUND(
        (SUM(funded_amnt - total_rec_prncp) / SUM(funded_amnt)) * 100,
        2
    ) AS breakeven_rate_needed_pct
FROM loans_clean
WHERE grade IN ('F', 'G')
GROUP BY grade;

-- Finding: To break even on realized losses alone, grade F would have
-- needed an average interest rate of 45.20% (vs. actual 27.28%), and
-- grade G would have needed 48.40% (vs. actual 29.90%) — increases of
-- roughly 18 and 19 percentage points respectively. These breakeven
-- rates are almost certainly impractical: they exceed typical usury
-- limits in most US states and would likely price out nearly all
-- borrowers who'd accept them, defeating the purpose of the loan
-- product. This reinforces that re-pricing is not a realistic fix for
-- grades F and G specifically and unlike grades B-E, where smaller rate
-- adjustments might plausibly close the gap, F and G's risk profile is
-- fundamentally too high for interest income to viably cover expected
-- losses. Exclusion (tightening approval criteria) is the more credible
-- lever for these two grades, while re-pricing remains a viable option
-- for the higher-volume B-E segments.
--
-- Note: this is a simplified breakeven estimate that treats loss as a
-- flat amount and does not account for compounding, time value of
-- money, or the fact that raising rates likely changes borrower
-- behavior and default rates themselves (a higher rate could itself
-- increase default risk — a limitation of this static estimate).