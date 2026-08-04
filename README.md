Loan Portfolio Risk & Profitability Analysis

Status: 🚧 In Progress — Milestone 1 of 9 (Environment & Repo Setup)

Overview

Consumer lending institutions aim to maximise profitable loan growth while minimising credit losses. However, underwriting decisions often rely on broad borrower classifications that may overlook important differences in default risk across customer segments. This project analyses historical consumer loan performance data (Lending Club, 2016–2018) to identify which borrower and loan characteristics contribute most to elevated default risk and reduced portfolio profitability, and translates those findings into practical underwriting and pricing recommendations.

Full problem statement and business objectives: 
docs/00_problem_statement.md

Table of Contents:
Business Questions
Tech Stack & Methodology
Project Structure
Data
How to Run This Project
Findings
Dashboard
Key Recommendations

Business Questions:
Which borrower segments generate the highest default risk?
Which loan characteristics are most associated with default, beyond credit grade alone?
How has portfolio risk changed over time (vintage analysis)?
Which segments provide the poorest risk-adjusted returns?
What is the potential financial impact of targeted underwriting changes?

Tech Stack & Methodology
Tools and their role in this project
SQL (PostgreSQL): Data cleaning, transformation, and  the core analytical queries answering the business questions above
Python (pandas, scipy): Statistical validation of SQL findings (e.g. significance testing) — not a duplicate EDA pass
Excel: Spot-check validation of key aggregates against SQL output
Power BI: Executive-facing interactive dashboard for stakeholder communication

Data flows one direction through this pipeline: raw CSV → SQL → Python validation → Power BI. Each stage's output is what the next stage consumes.

Project Structure
loan-portfolio-analysis/
├── data/
│   ├── raw/              # original data (gitignored — see Data section for download link)
│   ├── processed/        # cleaned output from SQL stage (gitignored)
│   ├── sample/           # small tracked sample so the repo is runnable out of the box
│   └── data_dictionary.md
├── sql/                  # schema, cleaning, and analysis queries
├── notebooks/            # exploratory validation notebooks
├── excel/                # validation workbook
├── powerbi/              # .pbix dashboard file
├── docs/                 # problem statement, data dictionary, findings write-up
└── images/               # dashboard screenshots for this README
Data

Source: Lending Club Loan Data (Kaggle) — 2016–2018 subset, ~[N] rows.

The full raw dataset is not committed to this repo (see .gitignore). To reproduce:

Download from the Kaggle link above
Place the CSV in data/raw/
Run sql/01_schema.sql then sql/02_cleaning.sql to reproduce the cleaned tables

A tracked sample is available at data/sample/ for quickly inspecting the data's shape without downloading the full file.

How to Run This Project:

git clone <this-repo-url>
cd loan-portfolio-analysis
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

Then follow the steps in the Data section to populate data/raw/, and run the SQL scripts in order.

Findings

Coming soon — populated once the analysis phase (Milestone 4) is complete.

Dashboard

Coming soon — screenshots and a walkthrough will be added once the Power BI build (Milestone 6) is complete.

Key Recommendations

Coming soon — final synthesis (Milestone 7).