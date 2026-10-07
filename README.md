# data-jobs-market-dwh
# Data Jobs Market Warehouse

A PostgreSQL data warehouse built on 12,217 LinkedIn job postings to answer one question: **what skills does the market demand from Data Engineers, compared with Data Analysts and Data Scientists?**

> 🚧 **Status: In progress.** Bronze layer and data profiling of the main table are done. Silver and Gold layers are next.

## Architecture

Medallion architecture with an ELT approach:

| Layer | Purpose | Status |
|---|---|---|
| Bronze | Raw 1:1 copy of the source CSV files | ✅ Done |
| Silver | Cleaned, typed, and standardized data | ⏳ Next |
| Gold | Star schema for analysis | ⬜ Planned |

## Data Source

- LinkedIn data job postings collected in January 2024.
- Dataset: [Data Science Job Postings & Skills (2024)](https://www.kaggle.com/datasets/asaniczka/data-science-job-postings-and-skills) by asaniczka on Kaggle (ODC Attribution License).
- 3 related files: `job_postings`, `job_skills`, `job_summary`, linked by `job_link`.
- Raw data is not stored in this repository. Download it from the link above.

## Tools

PostgreSQL 18, SQL, pgAdmin 4, GitHub

## Repository Structure

| File | Purpose |
|---|---|
| `scripts/00_init_database.sql` | Create the database and the bronze, silver, and gold schemas |
| `scripts/bronze/01_ddl_bronze.sql` | Create the bronze tables |
| `scripts/bronze/02_load_bronze.sql` | Load the CSV files (full load) |
| `scripts/bronze/03_verify_bronze.sql` | Verify row counts and sample rows |
| `scripts/bronze/04_profile_bronze.sql` | Data profiling to find quality issues |

## Key Profiling Findings (so far)

- 12,217 unique postings with no duplicates.
- 61.9% of job titles fall outside the three target roles, so a rule-based role classification was designed.
- Job location comes in 3 different structures, and the search country was wrong in 19 checked rows, so the real country is taken from the location when available.
- The data is a 6-day snapshot (January 12–17, 2024), and 84% of postings are from the US.

## Roadmap

- [x] Bronze layer
- [x] Data profiling: job_postings
- [ ] Data profiling: job_skills and job_summary
- [ ] Silver layer
- [ ] Gold star schema
- [ ] Analysis and final documentation
