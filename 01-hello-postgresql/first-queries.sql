
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