-- ============================================================
-- BI Data Model — Milestone 5
--
-- Restructures loans_clean into a star schema optimised for
-- Power BI: a fact table (fact_loans) plus supporting dimension
-- tables (dim_date, dim_grade). This is a separate step from
-- 02_cleaning.sql (data cleaning) and 03_analysis_queries.sql
-- (exploratory SQL analysis) — this file exists specifically to
-- prepare data for the dashboard build in Milestone 6.
-- ============================================================

-- ============================================================
-- Build dim_date: a calendar dimension covering the full range
-- of issue dates in loans_clean, for use in Power BI's date-based
-- filtering, trend charts, and vintage analysis views.
-- ============================================================

CREATE TABLE dim_date AS
SELECT
    d::date AS date_key,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(QUARTER FROM d) AS quarter,
    EXTRACT(MONTH FROM d) AS month_number,
    TO_CHAR(d, 'Month') AS month_name,
    TO_CHAR(d, 'Mon') AS month_short
FROM generate_series(
    (SELECT MIN(issue_date) FROM loans_clean),
    (SELECT MAX(issue_date) FROM loans_clean),
    '1 month'::interval
) AS d;

SELECT * FROM dim_date ORDER BY date_key LIMIT 12;

SELECT COUNT(*) AS total_months, MIN(date_key) AS earliest, MAX(date_key) AS latest
FROM dim_date;

-- ============================================================
-- Build dim_grade: a small dimension table listing each unique
-- loan grade (A-G). Provides a clean, standalone place to attach
-- descriptive grade metadata in Power BI (e.g. filtering, slicers,
-- or a future risk-tier grouping) without repeating that logic
-- across every visual.
-- ============================================================

CREATE TABLE dim_grade AS
SELECT DISTINCT grade FROM loans_clean ORDER BY grade;

-- ============================================================
-- Build fact_loans: the core fact table for the Power BI model.
-- Derived from loans_clean, with two additions purpose-built for
-- dashboard use:
--   - realized_loss: pre-calculated (funded_amnt - total_rec_prncp),
--     using the corrected loss logic from Business Question 4,
--     so it's ready to use directly as a Power BI measure.
--   - is_defaulted: a 1/0 flag version of loan outcome, letting
--     Power BI calculate default rate as a simple average.
-- loans_clean itself is left untouched, since it's the record of
-- the SQL analysis phase (Milestone 4) — fact_loans exists
-- specifically to feed the dashboard.
-- ============================================================

CREATE TABLE fact_loans AS
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
    issue_date,
    loan_status,
    purpose,
    dti,
    addr_state,
    total_pymnt,
    total_rec_int,
    total_rec_prncp,
    (funded_amnt - total_rec_prncp) AS realized_loss,
    CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END AS is_defaulted
FROM loans_clean;

SELECT COUNT(*) 
FROM fact_loans;