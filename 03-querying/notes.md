```markdown
# Chapter 3 - Querying With Purpose

## Key concepts
- Every SELECT is a question; the result is always a table
- PostgreSQL processes queries in this order FROM → WHERE → SELECT → ORDER BY → LIMIT
- NULL means "unknown", not "empty" - use IS NULL, never = NULL
- ILIKE is case-insensitive LIKE - use it for text searches

## Mistakes I made
- Have made mistake in COALESCE(nationality:: TEXT, 'UNKNOWN') where we didnt need to do any type casting cause the datatype was already TEXT
- I havent used IN function when looking for german and czech nationality authors in where clause
- I mistook BETWEEN and ILIKE as functions instead of treating them as operators
- forgot BETWEEN and AND syntax
- Question 14 was the one which made my brain go bzzzzzzz
- Lastly in question 15 i wrote 1950-12-31 instead of 1950-01-01


## Queries I'm proud of
- I love using ILIKE, INITCAP in a query
- Overall i find breaking the question in to SQL queries interesting. 

