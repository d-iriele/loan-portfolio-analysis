# Problem Statement

## Business Problem Statement

Consumer lending institutions aim to maximise profitable loan growth while minimising credit losses. However, underwriting decisions often rely on broad borrower classifications that may overlook important differences in default risk across customer segments. This project analyses historical consumer loan performance data to identify which borrower and loan characteristics contribute most to elevated default risk and reduced portfolio profitability. By evaluating lending outcomes across factors such as loan grade, purpose, debt-to-income ratio (DTI), employment length, loan term, geography, and issue year, this analysis provides data-driven recommendations that could improve underwriting policies, pricing strategies, and portfolio risk management while maintaining sustainable lending growth.

## Business Objective

The objective of this project is to evaluate the performance of a consumer loan portfolio and identify opportunities to improve lending decisions through data analysis. The project follows a deliberate pipeline: raw CSV → SQL (cleaning, transformation, and the core analytical queries answering the business questions below) → Python (statistical validation of SQL findings) → Excel (spot-check validation of key aggregates against SQL output) → Tableau Public (executive-facing interactive dashboard for stakeholder communication). The project aims to uncover high-risk borrower segments, measure portfolio concentration, quantify credit losses, and recommend practical actions that balance profitability with acceptable risk.

## Key Business Questions

**1. Which borrower segments generate the highest default risk?**
Analyse default rates across loan grade, loan purpose, home ownership, employment length, annual income bands, debt-to-income (DTI) ratio, and geographic location (state).
*Business value:* Allows risk teams to identify customer groups requiring tighter underwriting criteria or higher pricing.

**2. Which loan characteristics are most associated with loan default?**
Investigate whether variables such as loan term (36 vs 60 months), interest rate, loan amount, installment size, credit history length, and revolving utilisation provide additional predictive insight beyond the assigned credit grade.
*Business value:* Supports evidence-based underwriting decisions rather than relying solely on credit grade.

**3. How has portfolio risk changed over time?**
Perform a portfolio vintage analysis examining loan issue year, default rate by origination year, average loan amount over time, changes in borrower quality, and economic cycle effects.
*Business value:* Determines whether lending quality has improved or deteriorated over successive lending periods.

**4. Which segments provide the poorest risk-adjusted returns?**
Compare segments using both interest income potential and default losses to identify loans that generate relatively low returns for the amount of credit risk assumed.
*Business value:* Supports pricing adjustments and improved portfolio allocation.

**5. What is the potential financial impact of targeted underwriting changes?**
Estimate how tightening approval criteria for selected high-risk segments would affect expected defaults, portfolio loss, and portfolio composition.
*Business value:* Demonstrates how analytics can influence strategic lending policy rather than simply reporting historical performance.

## Project KPIs

| KPI | Formula | Business Purpose |
|---|---|---|
| Default Rate (%) | `COUNT(loan_status IN ('Charged Off','Default')) / COUNT(resolved loans)` | Percentage of loans that entered default or charge-off. Primary portfolio risk indicator. |
| Charge-Off Rate (%) | `SUM(charged-off principal) / SUM(total funded principal)`, resolved loans only | Measures realised credit losses within the portfolio. |
| Estimated Loss ($) | `SUM(funded_amnt − total_rec_prncp)` | Total principal never recovered. Note: `out_prncp` was found to be unreliable for this purpose, as Lending Club zeroes it at charge-off — see `docs/01_data_dictionary.md`. |
| Average Interest Rate (%) | `AVG(int_rate)` | Indicates pricing across borrower segments. |
| Average Loan Amount ($) | `AVG(loan_amnt)` | Identifies exposure size by customer segment. |
| Portfolio Concentration (%) | Share of loans by grade, purpose, state, or borrower type | Measures how exposure is distributed across segments. |
| Risk-Adjusted Return Proxy | `(SUM(total_rec_int) − SUM(funded_amnt − total_rec_prncp)) / SUM(funded_amnt)` | Interest income relative to estimated credit losses, as a total (not annualised) return over each loan's life. |
| Average Debt-to-Income Ratio | `AVG(dti)` | Measures borrower leverage across segments. |
| Average Annual Income | `AVG(annual_inc)` | Evaluates borrower affordability characteristics. |
| Default Rate by Vintage Year | Default rate grouped by `issue_date` year | Tracks portfolio quality over time (see time-censoring caveat in findings). |

## Project Scope

### Included
Historical consumer loans with sufficient performance history to evaluate lending outcomes: loan performance, borrower demographics, credit characteristics, geographic trends, portfolio segmentation, and historical trend analysis, using descriptive, diagnostic, and business intelligence techniques.

### Excluded
- Loans currently marked as "Current" with insufficient repayment history, where default outcomes remain uncertain.
- Predictive machine learning credit scoring models.
- Macroeconomic forecasting.
- External credit bureau data unavailable within the dataset.
- Individual borrower-level lending recommendations.

The project focuses on business analytics and decision support rather than predictive modelling.

## Expected Business Deliverables

By the conclusion of the project, stakeholders should be able to answer:
- Which customer segments contribute disproportionately to portfolio losses?
- Which loan characteristics are associated with increased default risk?
- How has lending quality evolved over time?
- Which regions or loan purposes require closer monitoring?
- Where should underwriting standards or pricing policies be adjusted to improve portfolio performance?