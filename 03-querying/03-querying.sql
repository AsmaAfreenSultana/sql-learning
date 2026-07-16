```sql
--Chapter 3: Querying With Purpose
--Knihy a Kafe bookshop queries
--Practising: SELECT, WHERE, ORDER BY, LIMIT, NULL handling,
--            pattern matching, DISTINCT, date/string functions
--
--Each query answers a question the bookshop manager might ask

--Q1: What is the most expensive book?
SELECT title, price FROM books ORDER BY price DESC limit 1;

--Q2: Which books cost less than 250 CZK?
SELECT title, price FROM books WHERE price < 250 AND price IS NOT NULL ORDER BY price DESC;

--Q3: How many books do we have in total?
SELECT COUNT(id) AS total_number_of_books FROM books;
--or SELECT COUNT(*) AS total_books FROM books;

--Q4: Which books were published before 1930?
SELECT title, published_date FROM books WHERE published_date < '1930-01-01' ORDER BY published_date DESC;

--Q5: What languages are our books written in?
SELECT DISTINCT original_language AS Avialable_Language FROM books WHERE original_language IS NOT NULL ORDER BY original_language;

--Q6: Which books have 'Kafka' in the title?
SELECT title FROM books WHERE INITCAP(title) ILIKE '%kafka%' ORDER BY title;

--Q7: Which Czech authors were born after 1880?
SELECT name, birth_year FROM authors WHERE (nationality = 'Czech') AND (birth_year > '1880-12-31') ORDER BY birth__year DESC;

--Q8: What are the 5 cheapest books that are currently in stock?
SELECT title, price FROM books WHERE in_stock = TRUE ORDER BY price LIMIT 5;
-- or in_stock = 't' and if we want to confirm availability in stock just write SELECT title, price, in_stock
--FROM books WHERE in_stock = TRUE ORDER BY price LIMIT 5;

--Q9: List all books between 200 and 300 CZK, sorted by title alphabetically.
SELECT title, price FROM books WHERE price BETWEEN 200 AND 300 ORDER BY title;

--Q10: Which books don't have a page count recorded?
SELECT title, pages FROM books WHERE page IS NULL ;

--Q11: Show all books with their price in both CZK and EUR (1 EUR ≈ 25 CZK). Round the EUR price to 2 decimal places.
SELECT title, price AS CZK, ROUND(price/25,2) AS EUR FROM books WHERE price IS NOT NULL ORDER BY title;
-- or ROUND(price*0.04,2) AS EUR

--Q12: Which books were originally written in Czech or German?
SELECT title, original_language FROM books WHERE INITCAP(original_langugae) IN ( 'czech', 'german') ORDER BY title;

--Q13: List authors with their birth year. If the birth year is unknown, show 'N/A' instead of NULL.
SELECT name, COALESCE(birth_year:: TEXT, 'N/A') AS birth_year FROM authors ORDER BY birth_year DESC;

--Q14: Show each author's name alongside how they would appear on a label: 'Name (Nationality, born YYYY)'. Handle missing data gracefully.
SELECT name || '(' COALESCE(nationality, 'unknown') || ', born'|| COALESCE(birth_year:: TEXT, '????') || ')' AS label FROM authors;

--Q15: Which books were published in the second half of the 20th century (1950–1999), cost more than 300 CZK, and are currently in stock?
SELECT title, published_date,price FROM books WHERE (published_date BETWEEN '1950-01-01' AND '1999-12-31') AND (price > 300) AND (in_stock = TRUE) ORDER BY published_date;
