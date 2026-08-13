--Show me each sale with the book title and customer name.

SELECT s.sale_date, b.title AS book, c.name AS cutomer, s.total_price from sales s JOIN books b ON s.book_id = b.id JOIN customers c ON s.customer_id = c.id ORDER BY s.sale_date;

--Which author's books have we sold the most copies of?

SELECT a.name AS name, SUM(s.quantity) AS total_copies_sold, b.title AS book FROM sales s JOIN books b ON s.book_id = b.id  JOIN authors a ON b.author_id = a.id GROUP BY a.name ORDER BY total_copies_sold DESC;

--Which books have never been sold?

SELECT b.title FROM books b LEFT JOIN sales s ON b.id = s.book_id WHERE s.id IS NULL ORDER BY b.title;

--Which customers have never made a purchase?

SELECT c.name FROM customers c LEFT JOIN sales s ON c.id = s.customer_id WHERE s.customer_id IS NULL ORDER BY c.name;

--Show all books with their author's name and nationality.

SELECT b.title, a.name, a.nationality FROM books b JOIN authors a ON b.author_id = a.id ORDER BY title;

--How much has each customer spent in total?

SELECT c.name AS customer, SUM(s.total_price) AS total_amount_spent FROM customers c JOIN sales s ON c.id = s.customer_id ORDER BY total_amount_spent DESC;
--SELECT DISTINCT c.name, SUM(total_price) FROM sales s JOIN customers c ON s.customer_id = c.id GROUP BY c.name ORDER BY c.name;

--Which customer bought the most expensive single item?

SELECT c.name AS customer, b.title AS book, s.total_price FROM sales s JOIN customers c ON s.customer_id = c.id JOIN books b ON s.book_id = b.id ORDER BY s.total_price DESC LIMIT 1;
--SELECT c.name AS customer, b.title AS book, s.total_price FROM customers c JOIN sales s ON c.id = s.customer_id JOIN books b ON b.id = s.book_id ORDER BY s.total_price DESC LIMIT 1;

--For each city, how many purchases were made?

SELECT c.city, COUNT(s.id) AS total_purchases  FROM customers c JOIN sales s ON c.id = s.customer_id GROUP BY c.city ORDER BY c.city;

--Show each author and how many different customers bought their books.

 SELECT a.name AS author, COUNT(DISTINCT s.customer_id) AS unique_customers FROM authors a JOIN books b ON a.id = b.author_id JOIN sales s ON b.id = s.book_id GROUP BY a.name ORDER BY unique_customers DESC;
--A BIT TOUGH ONE 

--Which author has generated the most total revenue?
SELECT a.name, SUM(s.total_price) AS top_revenue_earner FROM authors a JOIN books b ON a.book_id = b.id JOIN sales s ON s.book_id = b.id GROUP BY a.name ORDER BY top_revenue_earner DESC LIMIT 1;

--Find pairs of customers from the same city.


--Show all authors — including those whose books have never been sold — and their total revenue (0 if none).
SELECT a.name AS author, COALESCE(SUM(s.total_price), 0) AS total_revenue FROM authors a LEFT JOIN books b ON a.id = b.author_id LEFT JOIN sales s ON b.id = s.book_id GROUP BY a.name ORDER BY total_revenue DESC;

--List the most recent purchase for each customer.
SELECT c.name, MAX(s.sale_date) AS last_purchase FROM customers c JOIN sales s ON c.id = s.customer_id GROUP BY c.name ORDER BY last_purchase DESC;

--Show monthly revenue (how much was sold each month).
 SELECT DATE_TRUNC('month', s.sale_date)::DATE AS month, SUM(s.total_price) AS monthly_revenue, COUNT(s.id) AS number_of_sales FROM sales s  GROUP BY DATE_TRUNC('month', s.sale_date) ORDER BY month;

--Find pairs of customers from the same city.
SELECT c1.name AS customer_1, c2.name AS customer_2, c1.city FROM customers c1 JOIN customers c2 ON c1.city = c2.city AND c1.id < c2.id ORDER BY c1.city;

--What is the average sale price for books originally written in each language?
SELECT b.original_language, ROUND(AVG(s.total_price), 2) AS avg_sale_price, COUNT(s.id) AS number_of_sales FROM sales s JOIN books b ON s.book_id = b.id GROUP BY b.original_language ORDER BY avg_sale_price DESC;

