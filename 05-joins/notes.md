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

## Q&A

- When would you use LEFT JOIN instead of INNER JOIN?
   Ans: I would use LEFT JOIN when I need to retain all rows from the left table regardless of whether a match exists in the right table. 

   A common example is finding records with no counterpart — such as 
   books that have never been sold. I would LEFT JOIN sales onto books 
   and filter WHERE sales.id IS NULL to find those unmatched rows.

   INNER JOIN is the better choice when I only care about rows that 
   exist in both tables and unmatched rows are irrelevant to the question.

- what does Exercise 10 do?

  Ans: SELECT a.name, SUM(s.total_price) AS total_revenue
   -- Select the author's name and sum all their sales as total_revenue FROM authors a
   -- Start with the authors table — one row per author LEFT JOIN books b ON a.id b.author_id
   -- Link to books using author_id foreign key in books table
   -- LEFT JOIN keeps all authors even if they have no books
   LEFT JOIN sales s ON b.id = s.book_id
   -- Link to sales using book_id foreign key in sales table
   -- LEFT JOIN keeps all authors even if their books were never sold

   GROUP BY a.name
   -- Collapse all rows per author into one row so SUM works correctly
   ORDER BY total_revenue DESC
   -- Sort highest revenue first
   LIMIT 1
   -- Show only the top earning author

- Draw (or describe in text) the chain of tables for a query that shows: sale date, customer name, customer city, book title, author name, author nationality. Which table is the starting point? Which JOINs do you need?

  Ans:   Here our starting point is sales s table --> books b --> authors a we are using JOINs
  we are keeping sales s table which contains s.sale_date this will be our left table 
  so SELECT s.sale_date, c.name, c.city, b.title, a.name, a.nationality
  FROM sales s
  JOIN customers c ON s.customer_id = c.id
  JOIN books b ON s.book_id = b.id
 JOIN authors a ON b.author_id = a.id
 ORDER BY s.sale_date;
 sales (starting point)
  ↓ s.customer_id = c.id
 customers
  ↓ s.book_id = b.id  
 books
  ↓ b.author_id = a.id
 authors