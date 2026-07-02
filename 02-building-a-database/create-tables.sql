--Knihy a kafe Bookshop Database
--Chapter 2: Table creation
--
--Run this file to create the bookshop tables from scratch
--Requires: a database called knihy_kafe to exist.
--Usage: psql -U postgres -d knihy_kafe -f create-tables.sql

--Drop tables if they exist(so this script can be re-run cleanly)
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
--Authos table
CREATE TABLE authors (
id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
nationality TEXT,
birth_year SMALLINT
);
--Books table
CREATE TABLE books (
id SERIAL PRIMARY KEY,
title TEXT NOT NULL,
author_id INTEGER NOT NULL REFERENCES authors(id),
genre TEXT NOT NULL CHECK (genre IN (
'fiction', 'non-fiction', 'poetry',
'history', 'science','philosophy',
'children', 'biography'
)),
price NUMERIC(8,2) NOT NULL CHECK (price>0),
pages INTEGER CHECK (pages >0),
published_date DATE,
in_stock BOOLEAN DEFAULT TRUE NOT NULL, 
original_language TEXT DEFAULT 'Czech'
);
