
-- Chapter 1: First queries in PostgreSQL
-- These are exploratory queries to get comfortable with psql.

-- Basic arithmetic
SELECT 1 + 1 AS answer;

-- String output
SELECT 'Hello, PostgreSQL!' AS greeting;

-- Current date
SELECT current_date AS today;

-- PostgreSQL version
SELECT version();

-- Multi-value query
SELECT
    'Knihy a Kafe' AS bookshop_name,
    current_date AS today,
    3.14159 * 2 AS tau;
--Exercise 1 — Arithmetic
SELECT 365*24 AS hours_in_year;
--Exercise 2 — Text and concatenation
SELECT 'Knihy' || ' a ' || 'kafe' AS name;
--Exercise 3 — Current timestamp
SELECT current_timestamp AS now;
--Exercise 4 — PostgreSQL type casting
SELECT '42' ::INTEGER *2 AS result;
--Exercise 5 — Explore a system table
SELECT datname FROM pg_database;
--Exercise 6 — Error on purpose
SELECT * FROM nonexistent_table;