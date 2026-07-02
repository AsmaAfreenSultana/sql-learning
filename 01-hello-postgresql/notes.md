
# Chapter 1 — Hello PostgreSQL

## What I learned
- PostgreSQL is a client-server database (unlike SQLite which is just a file)
- psql is the command-line client — I type SQL, it sends it to the server
- SQL commands end with ; — backslash commands don't

## Things that surprised me
-when i dont end a statement with a semicolon it takes me to next line with a #- which i mistook as an error but 
--it was just waiting for continuation and it ends when i type ;

## Things I want to remember
-- Exercise 5:
-Metadata about the database is stored in tables.
-pg_database is a system table PostgreSQL maintains internally
- I can query it with regular select just like any other table.
--Exercise 6:
-- We cannot query a table that doesn't exist — PostgreSQL throws an error.
--PostgreSQL uses the word "relation" instead of "table" in error messages.
--A relation is PostgreSQL's general term for tables, views, and similar objects.
