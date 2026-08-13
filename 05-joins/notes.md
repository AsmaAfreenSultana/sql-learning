#Chapter 5 - Relationships and JOINs

## INNER JOIN vs LEFT JOIN 
INNER JOIN returns only rows that have a match in both tables. If a row in the left table has no matching row in the right table, 
it is excluded from the results entirely.

LEFT JOIN returns ALL rows from the left table, even if there is no match in the right table. Where there is no match, the right 
table's columns show NULL.

## The LEFT JOIN + IS NULL pattern

Example: SELECT b.title FROM books b LEFT JOIN sales s ON b.id = s.book_id WHERE s.id IS NULL;

We put books on the LEFT so all books are kept even with no sales.

WHERE s.id IS NULL then filters to show ONLY the unmatched books —
those that appear in books but have no corresponding row in sales.

We check s.id specifically because it's the primary key of sales —
it will always be NULL when there's no match, making it a reliable indicator of "no sale exists for this book.

## When to use which JOIN type
- "Show me X that has Y" → INNER JOIN
- "Show me ALL X, with Y if it exists" → LEFT JOIN
- "Show me X that has NO Y" → LEFT JOIN + WHERE IS NULL

## Queries I found challenging

Exercise- 6: How much has each customer spent in total?. This was the point where i discovered that GROUP BY clause is used when we 
are only one column rest columns can exists if and only if there dont need a separate GROUP BY clause which is when we are using
functions like COUNT(), MIN(), MAX(), AVG(), SUM().

Exercise- 8: For each city, how many purchases were made? 

well i tried to solve this query on my own i knew i needed to use COUNT() 
then i got lost and didnt use that function at all when i researched the answer it was so simple Initially missed that GROUP BY requires all non-aggregated columns — now understood

Exercise- 9: Show each author and how many different customers bought their books.

Okay so i did the JOINs syntax right but rest filtering 
of columns were wrong i was so wrong in this query Confused COUNT with SUM — learned they answer different questions.

Exercise - 10 to 15: i did half way correct and half of my syntax was wrong the only thing i could do correctly was joining the tables.

## Key insight from this chapter

What I have learned from this chapter is that up until now I was having fun and found it easy. I was fine from chapter 1-4 when I started
building the queries in this chapter I had to use book and pen to solve the queries in this exercise. it is challenging for me. I am pretty
confident I will catch up and become more comfortable as the exercises keeps getting more and more difficult.