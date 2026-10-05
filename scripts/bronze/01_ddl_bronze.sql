/*
=============================================================
DDL Script: Create Bronze Tables
=============================================================
Purpose:
    Creates the bronze layer tables as a 1:1 raw copy of
    the source CSV files. All columns are TEXT on purpose.

Warning:
    Running this script drops and recreates the tables,
    so any loaded data will be deleted.
=============================================================
*/

DROP TABLE IF EXISTS bronze.job_postings;
CREATE TABLE bronze.job_postings (
    job_link             TEXT,
    last_processed_time  TEXT,
    last_status          TEXT,
    got_summary          TEXT,
    got_ner              TEXT,
    is_being_worked      TEXT,
    job_title            TEXT,
    company              TEXT,
    job_location         TEXT,
    first_seen           TEXT,
    search_city          TEXT,
    search_country       TEXT,
    search_position      TEXT,
    job_level            TEXT,
    job_type             TEXT
);

DROP TABLE IF EXISTS bronze.job_skills;
CREATE TABLE bronze.job_skills (
    job_link    TEXT,
    job_skills  TEXT
);

DROP TABLE IF EXISTS bronze.job_summary;
CREATE TABLE bronze.job_summary (
    job_link     TEXT,
    job_summary  TEXT
);