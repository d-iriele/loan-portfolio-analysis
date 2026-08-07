# Findings Summary: Consumer Loan Portfolio Risk & Profitability Analysis

## Executive Summary

Analysis of 518,372 consumer loans issued between 2016 and 2018 shows that the current lending strategy is not adequately pricing credit risk. After accounting for realised losses, only Grade A loans generated a positive risk-adjusted return, while Grades B through G collectively destroyed value. Default risk increases consistently across loan grades—from 6.8% for Grade A to 53.6% for Grade G—and is further concentrated in segments such as small business lending, highlighting that losses are driven by identifiable borrower characteristics rather than random variation. While excluding the highest-risk Grades F and G would have prevented $73.8 million in losses, this alone would not restore portfolio profitability, because the greatest share of losses originates from the much larger B–E segments. The findings therefore suggest that improving portfolio performance requires a combination of targeted risk-based pricing and tighter underwriting standards, rather than simply eliminating the riskiest borrowers.

## Business Context & Objective

Consumer lending institutions aim to grow their loan portfolios while keeping credit losses within acceptable limits. Underwriting decisions are often based on broad classifications—such as an assigned credit grade—that may not fully capture differences in risk across borrower segments. This analysis evaluates historical loan performance to identify which segments carry disproportionate default risk relative to the returns they generate, and to recommend practical adjustments to underwriting and pricing policy.

## Key Findings

**1. Which borrower segments generate the highest default risk?**
Loan grade is the strongest and most reliable predictor of default risk, with default rates increasing almost eightfold from 6.83% for Grade A to 53.56% for Grade G. Beyond credit grade, small business loans exhibit the highest meaningful default rate (34.53%, excluding purposes with fewer than 100 loans) among loan purposes, while renters default substantially more often than borrowers with a mortgage (27.17% vs. 18.67%). Together, these findings indicate that borrower risk is concentrated in identifiable segments, providing clear opportunities for more targeted underwriting and pricing.

**2. Which loan characteristics are most associated with default, beyond credit grade alone?**
Loan characteristics beyond credit grade also provide meaningful predictive value. 60-month loans default at nearly twice the rate of 36-month loans (33.45% vs. 19.23%), despite an interest rate only modestly higher (17.23% vs. 12.28%), suggesting longer loan terms introduce additional risk that is not fully reflected in pricing. In addition, defaulted borrowers have higher average debt-to-income ratios (20.60 vs. 18.25), supporting the case for incorporating DTI more directly into lending decisions rather than relying on credit grade alone.

**3. How has portfolio risk changed over time (vintage analysis)?**
At face value, portfolio risk appears to improve over time, with default rates falling from 23.28% in 2016 to 15.76% in 2018 alongside a sharp decline in loan volume. However, this pattern is largely explained by time censoring: the dataset only includes loans with resolved outcomes, meaning many 2018 loans were still current and therefore excluded from the analysis. Since borrower characteristics such as average DTI and interest rates remained broadly stable across all three years, there is little evidence that underwriting standards materially changed during this period.

**4. Which segments provide the poorest risk-adjusted returns?**
Risk-adjusted profitability deteriorates consistently as borrower risk increases, with Grade A being the only segment to generate a positive realised return (1.77%). Every other grade produced negative returns, falling to -26.99% for Grade G, demonstrating that higher interest rates failed to compensate for realised credit losses. This indicates that the existing pricing strategy systematically underpriced credit risk across the majority of the portfolio.

**5. What is the potential financial impact of targeted underwriting changes?**
Excluding the highest-risk Grades F and G would have prevented approximately $73.8 million in realised losses while affecting only around 3% of loans and 4% of funded volume. Re-pricing is not a realistic alternative for these two grades specifically: breakeven analysis shows Grade F would have required an average interest rate of 45.20% and Grade G 48.40% to offset realised losses—well beyond practical lending limits—making exclusion the more credible lever here. However, the remaining portfolio would still generate substantial losses because the much larger Grades B-E account for the majority of negative returns. The analysis therefore suggests that meaningful improvement requires re-pricing or tighter underwriting across the middle-risk segments, rather than simply eliminating the riskiest borrowers.

## Recommendations

**1. Prioritize re-pricing and tighter underwriting for Grades B-E.**
The analysis shows that excluding Grades F and G alone is insufficient to restore a positive realised return. Even after removing these highest-risk segments, the retained Grades A-E portfolio still produced a realised loss of approximately $432.8 million, indicating that the primary source of value destruction lies in the much larger middle-grade segments. Management should review pricing, affordability thresholds, and approval criteria for Grades B-E to better align expected returns with realised credit risk.

**2. Exclude or substantially restrict lending to Grades F and G.**
Grades F and G generated the poorest risk-adjusted returns despite carrying the highest interest rates. Achieving break-even would require estimated interest rates of approximately 45-48%, far above the rates observed in the portfolio and likely impractical within market and regulatory constraints. Unless underwriting can materially reduce default rates, these grades should be significantly restricted or removed from future lending.

**3. Introduce enhanced underwriting for small business and other high-risk borrower segments.**
Beyond credit grade, small business loans exhibited the highest meaningful default rate (34.53%) and represented approximately $91 million in funded volume within the cleaned portfolio, while renters also showed substantially higher default rates than borrowers with mortgages. These segments should undergo additional affordability and income verification, with greater emphasis placed on debt-to-income ratios and repayment capacity before loan approval.

**4. Interpret vintage performance trends with caution when monitoring portfolio risk.**
Although default rates appear to decline across loan vintages, this improvement is primarily driven by time censoring, as more recent loans have had less time to reach a resolved outcome. Future portfolio reporting should therefore distinguish between resolved and active loans—or use survival analysis or loan seasoning methods—to avoid drawing misleading conclusions about underwriting performance over time.

## Limitations

While the analysis identifies clear patterns in portfolio risk and profitability, several limitations should be considered when interpreting the results.

- **Risk-adjusted returns are total realised returns, not annualised performance.** All return calculations reflect each loan's cumulative performance over its full life (up to five years) rather than a yearly yield. As a result, the figures are most appropriate for comparing segments within this portfolio rather than benchmarking against annual investment returns.

- **The break-even interest rate estimates are simplified.** The estimated rates required for loss-making grades to break even assume that all other factors remain constant and do not account for behavioural changes, prepayments, changing borrower demand, or the impact that higher pricing could have on default rates. They should therefore be interpreted as indicative rather than operational pricing recommendations.

- **Re-pricing recommendations for Grades B-E are directional, not quantified.** Unlike the break-even analysis performed for Grades F and G, this study did not calculate a specific target interest rate for Grades B-E. Further analysis would be needed to determine the precise pricing or underwriting adjustments required to restore positive returns in these segments.

- **Borrower financial characteristics may contain measurement error.** Variables such as annual income and debt-to-income (DTI) ratio are based on borrower-reported information collected at origination and are not independently verified in all cases (see `verification_status`). Any inaccuracies or subsequent changes in borrowers' financial circumstances are not captured, which may weaken the observed relationships between these variables and default—including the DTI gap identified in Finding 2 (20.60 vs. 18.25).

- **Macroeconomic conditions were not incorporated into the analysis.** The study focuses on borrower and loan characteristics but does not control for external factors such as interest rate movements, unemployment, or regional economic conditions, all of which can materially influence default behaviour. Consequently, the findings identify strong associations rather than establishing causal relationships.