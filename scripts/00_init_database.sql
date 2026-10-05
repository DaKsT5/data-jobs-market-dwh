/*
=============================================================
Create Database and Schemas
=============================================================
Purpose:
    Creates the 'data_jobs_dwh' database and three schemas
    for the Medallion Architecture: bronze, silver, gold.

Note:
    Run Part 1 while connected to the 'postgres' database.
    Run Part 2 while connected to the 'data_jobs_dwh' database.
=============================================================
*/

-- Part 1: Create the database
CREATE DATABASE data_jobs_dwh;

-- Part 2: Create the schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;