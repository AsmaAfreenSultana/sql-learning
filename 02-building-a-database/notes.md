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
- Primary key uniquely defines a column which later can be accessed while referencing.
  Multiple people can have same name hence it can create duplicate data which is why a person
  name cannot be a Primary Key.Also, names can change over time. A primary key must be stable 
  and permanent — if it changes, all foreign keys referencing it 
  break. A SERIAL id never changes, making it a reliable primary key.
- NOT NULL ensures that the data inserted inside a column has a value guaranteed to be entered.
  Imagine you're signing up for a website and the email field is left blank.
  NOT NULL on the email column would reject that row entirely — you can't 
  create an account without an email address. It guarantees the field 
  always has something in it.
- In the bookshop database design i would add series section inside books cause each book can have
  multiple series and sequels.A separate 'series' table would be needed:
- series: id, name, total_books
- books would then have a series_id column referencing series(id)

- This way one series can have many books linked to it,
  without repeating the series name on every book row.
