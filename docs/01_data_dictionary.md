# Data Dictionary

Source: Lending Club Loan Data (Kaggle) — "accepted_2007_to_2018Q4.csv"
URL: https://www.kaggle.com/datasets/wordsforthewise/lending-club?select=accepted_2007_to_2018Q4.csv.gz
Raw row count: 2,260,701 | Raw column count: 151


## loans_raw

| Column | Type | Description | Notes |
|---|---|---|---|
| loan_status | text | Current status of the loan (e.g. Fully Paid, Charged Off, Current) | Core outcome variable for default analysis |
| grade | text | Lending Club's assigned credit grade (A–G) | |
| int_rate | numeric | Interest rate on the loan (%) | |
| dti | numeric | Debt-to-income ratio: monthly debt payments / monthly income | High values = higher borrower leverage |
| term | text | Loan repayment term (36 or 60 months) | |
| annual_inc | numeric | Self-reported annual income | |
| issue_d | date | Month/year loan was issued | Used for vintage analysis |
| addr_state | text | Borrower's US state | |

## loans_clean (derived table)

Filtered and transformed from `loans_raw`. Scope: loans issued 2016–2018 with a resolved outcome (Fully Paid, Charged Off, or Default), excluding rows with missing DTI or annual income. Defined in `sql/02_cleaning.sql`.

Row count: 518,372 (from 2,260,701 in loans_raw)

| Column | Type | Notes |
|---|---|---|
| id | text | Unique loan identifier |
| loan_amnt | numeric | Original requested/funded loan amount |
| funded_amnt | numeric | Total amount funded by investors |
| term | text | 36 or 60 months |
| int_rate | numeric | Interest rate (%) |
| installment | numeric | Monthly payment amount |
| grade | text | Lending Club's assigned credit grade (A–G) |
| sub_grade | text | Finer-grained grade (e.g. B3) |
| emp_length | text | Borrower's reported years of employment |
| home_ownership | text | RENT, OWN, MORTGAGE, ANY, NONE |
| annual_inc | numeric | Self-reported annual income |
| verification_status | text | Whether income was verified by Lending Club |
| issue_date | date | Converted from original text format (Mon-YYYY) via TO_DATE |
| loan_status | text | Restricted to 3 resolved outcomes only (see scope above) |
| purpose | text | Borrower-stated reason for the loan |
| dti | numeric | Debt-to-income ratio |
| addr_state | text | Borrower's US state |
| total_pymnt | numeric | Total amount repaid to date (principal + interest) — added to support risk-adjusted return calculation (Business Question 4) |
| total_rec_int | numeric | Total interest actually collected — added to support risk-adjusted return calculation |
| total_rec_prncp | numeric | Total principal actually recovered — added to support risk-adjusted return calculation |
| out_prncp | numeric | Outstanding principal never recovered — used as realized loss in risk-adjusted return calculation |