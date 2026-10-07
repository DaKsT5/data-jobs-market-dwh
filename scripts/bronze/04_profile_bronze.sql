/*
=============================================================
Profiling Script: Explore Bronze Data Quality
=============================================================
Purpose:
    Explores the bronze tables to find data quality issues
    (duplicates, missing values, inconsistent values) before
    cleaning them in the silver layer.

Usage:
    Run each query separately with "Execute query".
=============================================================
*/



-- ==========================================================
-- Table: job_postings
-- ==========================================================


-- 1) Duplicate check: is job_link unique?
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT job_link) AS unique_links,
    COUNT(*) - COUNT(DISTINCT job_link) AS duplicate_rows
FROM bronze.job_postings;

-- 2) Missing values: NULL or empty text in all columns
SELECT
    COUNT(*) FILTER (WHERE job_link IS NULL OR TRIM(job_link) = '') AS missing_job_link,
    COUNT(*) FILTER (WHERE last_processed_time IS NULL OR TRIM(last_processed_time) = '') AS missing_last_processed_time,
    COUNT(*) FILTER (WHERE last_status IS NULL OR TRIM(last_status) = '') AS missing_last_status,
    COUNT(*) FILTER (WHERE got_summary IS NULL OR TRIM(got_summary) = '') AS missing_got_summary,
    COUNT(*) FILTER (WHERE got_ner IS NULL OR TRIM(got_ner) = '') AS missing_got_ner,
    COUNT(*) FILTER (WHERE is_being_worked IS NULL OR TRIM(is_being_worked) = '') AS missing_is_being_worked,
    COUNT(*) FILTER (WHERE job_title IS NULL OR TRIM(job_title) = '') AS missing_job_title,
    COUNT(*) FILTER (WHERE company IS NULL OR TRIM(company) = '') AS missing_company,
    COUNT(*) FILTER (WHERE job_location IS NULL OR TRIM(job_location) = '') AS missing_job_location,
    COUNT(*) FILTER (WHERE first_seen IS NULL OR TRIM(first_seen) = '') AS missing_first_seen,
    COUNT(*) FILTER (WHERE search_city IS NULL OR TRIM(search_city) = '') AS missing_search_city,
    COUNT(*) FILTER (WHERE search_country IS NULL OR TRIM(search_country) = '') AS missing_search_country,
    COUNT(*) FILTER (WHERE search_position IS NULL OR TRIM(search_position) = '') AS missing_search_position,
    COUNT(*) FILTER (WHERE job_level IS NULL OR TRIM(job_level) = '') AS missing_job_level,
    COUNT(*) FILTER (WHERE job_type IS NULL OR TRIM(job_type) = '') AS missing_job_type
FROM bronze.job_postings;

-- 3) Distinct values in job_type
SELECT job_type, COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY job_type
ORDER BY job_count DESC;

-- 4) Cardinality: number of distinct values in each column
SELECT
    COUNT(DISTINCT job_link) AS job_link,
    COUNT(DISTINCT last_processed_time) AS last_processed_time,
    COUNT(DISTINCT last_status) AS last_status,
    COUNT(DISTINCT got_summary) AS got_summary,
    COUNT(DISTINCT got_ner) AS got_ner,
    COUNT(DISTINCT is_being_worked) AS is_being_worked,
    COUNT(DISTINCT job_title) AS job_title,
    COUNT(DISTINCT company) AS company,
    COUNT(DISTINCT job_location) AS job_location,
    COUNT(DISTINCT first_seen) AS first_seen,
    COUNT(DISTINCT search_city) AS search_city,
    COUNT(DISTINCT search_country) AS search_country,
    COUNT(DISTINCT search_position) AS search_position,
    COUNT(DISTINCT job_level) AS job_level,
    COUNT(DISTINCT job_type) AS job_type
FROM bronze.job_postings;

-- 5a) Distinct values in job_level
SELECT job_level, COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY job_level
ORDER BY job_count DESC;

-- 5b) Distinct values in search_country
SELECT search_country, COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY search_country
ORDER BY job_count DESC;

-- 5c) Distinct values in first_seen
SELECT first_seen, COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY first_seen
ORDER BY first_seen;

-- 5d) The single value in each constant column
SELECT last_status, got_summary, got_ner, is_being_worked, COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY last_status, got_summary, got_ner, is_being_worked;

-- 6) Range and format of last_processed_time
SELECT
    MIN(last_processed_time) AS earliest,
    MAX(last_processed_time) AS latest,
    MIN(LENGTH(last_processed_time)) AS min_length,
    MAX(LENGTH(last_processed_time)) AS max_length
FROM bronze.job_postings;

-- 7) Extra spaces at the start or end of text values (all columns)
SELECT
    COUNT(*) FILTER (WHERE job_link <> TRIM(job_link)) AS job_link,
    COUNT(*) FILTER (WHERE last_processed_time <> TRIM(last_processed_time)) AS last_processed_time,
    COUNT(*) FILTER (WHERE last_status <> TRIM(last_status)) AS last_status,
    COUNT(*) FILTER (WHERE got_summary <> TRIM(got_summary)) AS got_summary,
    COUNT(*) FILTER (WHERE got_ner <> TRIM(got_ner)) AS got_ner,
    COUNT(*) FILTER (WHERE is_being_worked <> TRIM(is_being_worked)) AS is_being_worked,
    COUNT(*) FILTER (WHERE job_title <> TRIM(job_title)) AS job_title,
    COUNT(*) FILTER (WHERE company <> TRIM(company)) AS company,
    COUNT(*) FILTER (WHERE job_location <> TRIM(job_location)) AS job_location,
    COUNT(*) FILTER (WHERE first_seen <> TRIM(first_seen)) AS first_seen,
    COUNT(*) FILTER (WHERE search_city <> TRIM(search_city)) AS search_city,
    COUNT(*) FILTER (WHERE search_country <> TRIM(search_country)) AS search_country,
    COUNT(*) FILTER (WHERE search_position <> TRIM(search_position)) AS search_position,
    COUNT(*) FILTER (WHERE job_level <> TRIM(job_level)) AS job_level,
    COUNT(*) FILTER (WHERE job_type <> TRIM(job_type)) AS job_type
FROM bronze.job_postings;

-- 8a) Most common job titles
SELECT job_title, COUNT(*) AS title_count
FROM bronze.job_postings
GROUP BY job_title
ORDER BY title_count DESC
LIMIT 30;

-- 8b) Preview the job role classification
SELECT
    CASE
        WHEN job_title ILIKE '%data engineer%' THEN 'Data Engineer'
        WHEN job_title ILIKE '%data analyst%' THEN 'Data Analyst'
        WHEN job_title ILIKE '%data scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_role,
    COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY job_role
ORDER BY job_count DESC;

-- 8c) Most common titles that fall into 'Other'
SELECT job_title, COUNT(*) AS title_count
FROM bronze.job_postings
WHERE job_title NOT ILIKE '%data engineer%'
  AND job_title NOT ILIKE '%data analyst%'
  AND job_title NOT ILIKE '%data scientist%'
GROUP BY job_title
ORDER BY title_count DESC
LIMIT 50;

-- 8d) Final job role classification (with 'data science' rule)
SELECT
    CASE
        WHEN job_title ILIKE '%data engineer%' THEN 'Data Engineer'
        WHEN job_title ILIKE '%data analyst%' THEN 'Data Analyst'
        WHEN job_title ILIKE '%data scientist%' OR job_title ILIKE '%data science%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_role,
    COUNT(*) AS job_count
FROM bronze.job_postings
GROUP BY job_role
ORDER BY job_count DESC;

-- 9) Structure of job_location: number of commas in each value
SELECT
    LENGTH(job_location) - LENGTH(REPLACE(job_location, ',', '')) AS comma_count,
    COUNT(*) AS location_count,
    MIN(job_location) AS example_value
FROM bronze.job_postings
GROUP BY comma_count
ORDER BY comma_count;

-- 9b) Locations with no commas
SELECT job_location, COUNT(*) AS location_count
FROM bronze.job_postings
WHERE job_location NOT LIKE '%,%'
GROUP BY job_location
ORDER BY location_count DESC
LIMIT 30;

-- 9c) Does search_country match the country written in job_location?
SELECT
    search_country,
    TRIM(SPLIT_PART(job_location, ',', 3)) AS location_country,
    COUNT(*) AS location_count
FROM bronze.job_postings
WHERE LENGTH(job_location) - LENGTH(REPLACE(job_location, ',', '')) = 2
GROUP BY search_country, location_country
ORDER BY location_count DESC;
