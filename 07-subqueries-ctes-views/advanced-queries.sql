--Exercise 1: "Which books have a price above the average price of their genre?"
WITH genre_avg AS (
    SELECT genre, ROUND(AVG(price), 2) AS avg_price
    FROM books
    GROUP BY genre
)
SELECT 
    b.title,
    b.genre,
    b.price,
    ga.avg_price
FROM books b
JOIN genre_avg ga ON b.genre = ga.genre
WHERE b.price > ga.avg_price
ORDER BY b.genre, b.price DESC;

--Exercise 2: "Which customers have spent more than the average customer?"
WITH cust_spent AS (
    SELECT c.name AS customer, 
        SUM(s.total_price) AS total_spent
    FROM sales s
    JOIN customers c ON s.customer_id = c.id
    GROUP BY c.name
),
avg_spent AS (
    SELECT ROUND(AVG(total_spent), 2) AS avg_spent
    FROM cust_spent
)
SELECT 
    cs.customer,
    cs.total_spent,
    av.avg_spent
FROM cust_spent cs
CROSS JOIN avg_spent av
WHERE cs.total_spent > av.avg_spent
ORDER BY total_spent DESC;

--Exercise 4: "Using a CTE, find each author's best-selling book (by revenue).
--WITH book_revenue AS ( SELECT b.author_id, b.title, SUM(s.total_price) AS revenue FROM books b JOIN sales s ON b.id = s.book_id GROUP BY b.author_id, b.title ) SELECT DISTINCT ON (a.name) a.name AS author, br.title AS best_seller, br.revenue FROM authors a JOIN book_revenue br ON a.id = br.author_id ORDER BY a.name, br.revenue DESC;
WITH author_revenue AS (
    SELECT a.name AS author, 
        b.title AS title, 
        SUM(s.quantity) AS copies_sold, 
        SUM(s.total_price) AS total_revenue 
    FROM sales s 
    JOIN books b ON s.book_id = b.id 
    JOIN authors a ON b.author_id = a.id 
    GROUP BY a.name, b.title
) 
SELECT DISTINCT ON (ar.author) 
    ar.author, ar.title, ar.copies_sold, ar.total_revenue 
FROM author_revenue ar 
ORDER BY ar.author, ar.total_revenue DESC;

--Exercise 5: "Show the top 3 customers by total spending, along with a list of all book titles they purchased."
--WITH top_customers AS ( SELECT c.id, c.name, SUM(s.total_price) AS total_spent FROM customers c JOIN sales s ON c.id = s.customer_id GROUP BY c.id, c.name ORDER BY total_spent DESC LIMIT 3 ), customer_books AS ( SELECT tc.name, tc.total_spent, STRING_AGG(DISTINCT b.title, ', ' ORDER BY b.title) AS books_purchased FROM top_customers tc JOIN sales s ON tc.id = s.customer_id JOIN books b ON s.book_id = b.id GROUP BY tc.name, tc.total_spent ) SELECT * FROM customer_books ORDER BY total_spent DESC;
WITH top_customers AS (
    SELECT c.name AS customer, 
        SUM(s.total_price) AS total_spent
    FROM sales s
    JOIN customers c ON s.customer_id = c.id
    GROUP BY c.name
    ORDER BY total_spent DESC
    LIMIT 3
),
customer_books AS (
    SELECT c.name AS customer,
        STRING_AGG(DISTINCT b.title, ', ' ORDER BY b.title) AS books_purchased
    FROM sales s
    JOIN customers c ON s.customer_id = c.id
    JOIN books b ON s.book_id = b.id
    GROUP BY c.name
)
SELECT 
    tc.customer,
    tc.total_spent,
    cb.books_purchased
FROM top_customers tc
JOIN customer_books cb ON tc.customer = cb.customer
ORDER BY tc.total_spent DESC;


--Exercise 7: "Using EXISTS, find authors whose books have been purchased by customers from Prague."
--SELECT a.name FROM authors a WHERE EXISTS ( SELECT 1 FROM books b JOIN sales s ON b.id = s.book_id JOIN customers c ON s.customer_id = c.id WHERE b.author_id = a.id AND c.city = 'Prague' ) ORDER BY a.name; 

WITH author_revenue AS ( SELECT a.name AS author, SUM(s.quantity) AS copies_sold, SUM(s.total_price) AS total_revenue, c.city AS city, COUNT(s.id) AS number_of_sales, COUNT(DISTINCT customer_id) AS number_of_customers FROM sales s JOIN customers c ON s.customer_id = c.id JOIN books b ON s.book_id = b.id JOIN authors a ON b.author_id = a.id WHERE EXISTS( SELECT 1 FROM sales s WHERE s.customer_id = c.id AND c.city = 'Prague') GROUP BY a.name, c.city ORDER BY total_revenue DESC) SELECT * FROM author_revenue;
