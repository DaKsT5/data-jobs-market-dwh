/*
=============================================================
Verification Script: Check Bronze Layer Load
=============================================================
Purpose:
    Verifies that the bronze tables were loaded correctly
    by checking row counts and previewing sample rows.

Usage:
    Run each query separately (place the cursor inside the
    query and use "Execute query") to see each result.
=============================================================
*/

-- 1) Row count for each bronze table
SELECT 'job_postings' AS table_name, COUNT(*) AS row_count FROM bronze.job_postings
UNION ALL
SELECT 'job_skills', COUNT(*) FROM bronze.job_skills
UNION ALL
SELECT 'job_summary', COUNT(*) FROM bronze.job_summary;

-- 2) Preview the first 10 rows of job_postings
SELECT * FROM bronze.job_postings LIMIT 10;

-- 3) Preview the first 10 rows of job_skills
SELECT * FROM bronze.job_skills LIMIT 10;

-- 4) Preview the first 10 rows of job_summary
SELECT * FROM bronze.job_summary LIMIT 10;