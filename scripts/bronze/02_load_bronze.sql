/*
=============================================================
Load Script: Load Bronze Layer (Source -> Bronze)
=============================================================
Purpose:
    Loads the raw CSV files into the bronze tables using a
    full load: truncate each table, then copy the file in.

Warning:
    Running this script deletes the current data in the
    bronze tables before reloading it.
=============================================================
*/

-- 1) job_postings
TRUNCATE TABLE bronze.job_postings;
COPY bronze.job_postings
FROM 'C:/data-jobs-market-dwh/datasets/job_postings.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- 2) job_skills
TRUNCATE TABLE bronze.job_skills;
COPY bronze.job_skills
FROM 'C:/data-jobs-market-dwh/datasets/job_skills.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- 3) job_summary
TRUNCATE TABLE bronze.job_summary;
COPY bronze.job_summary
FROM 'C:/data-jobs-market-dwh/datasets/job_summary.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');