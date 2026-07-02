# Chapter 2 - Building Your First Database

## What I learned

### Data types I used
- SERIAL - autho-incrementing integer for primary keys
- TEXT - general strings (names, titles)
- INTEGER / SMALLINT - whole numbers
- NUMERIC(8,2) - exact decimal numbers (for prices)
- DATE - calendar dates
- BOOLEAN - true/ false values

### Constraints I used 
- PRIMARY KEY - unique identifier for each row
- NOT NULL - column cannot be empty
- CHECK - custom validation rule
- DEFAULT - automatic valuse when none is specified
- REFERENCES - foreign key linking to another table

## Key insight
Constraints make sure only valid data enters the database. 
For example, a price column with CHECK (price > 0) will reject 
a price of -50 or 0 because that makes no sense for a bookshop. 
The database enforces these rules automatically so I don't have 
to check the data manually every time something is inserted.

## Things I want to remember
- Git bash will ask the password inorder to run the following command
  psql -U postgres -d new-database -f folder-name/file-name.sql
- In psql shell use the following command to run the file
  \i 'Disk/Users/User-name/Parent-folder-name/Sub-folder-name/file-name.sql'
- Remember: psql -f runs a SQL file against a specific database 
  from the terminal. The -d flag specifies which database to use.
- The \i command inside SQL Shell and psql -f from the terminal 
  do the same thing — both run a SQL file. Use \i when already 
  inside psql, use psql -f from Git Bash.
-