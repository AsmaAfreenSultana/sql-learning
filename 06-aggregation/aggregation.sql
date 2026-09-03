--Exercise 1: "What is the total revenue from all sales?"
SELECT SUM(total_price) AS total_revenue FROM sales; 
--Or SELECT COUNT(s.id) AS Number_of_sales, ROUND(AVG(s.total_price), 2) AS Average_sale_price, SUM(s.total_price) AS total_revenue_earned FROM sales s;

--Exercise 2: "How many sales did we make each month, and what was the monthly revenue?"

SELECT DATE_TRUNC('month', sale_date)::DATE AS month, COUNT(*) AS sales_count, SUM(total_price) AS revenue FROM sales GROUP BY DATE_TRUNC('month', sale_date) ORDER BY month;
--Or SELECT DATE_TRUNC('MONTH', s.sale_date)::DATE AS month, COUNT(s.id) AS Monthly_sales, SUM(s.quantity) AS copies_sold, SUM(s.total_price) AS Monthly_Revenue, ROUND(AVG(s.total_price), 2) AS Average_Monthly_sale_price FROM sales s GROUP BY DATE_TRUNC('MONTH', s.sale_date) ORDER BY Monthly_Revenue DESC;

--Exercise 3: "What is the average price of books in each genre?"
SELECT genre, ROUND(AVG(price), 2) AS avg_price, COUNT(*) AS book_count FROM books GROUP BY genre ORDER BY avg_price DESC;

-- Or SELECT genre, ROUND(AVG(price), 2) AS Average_price FROM books GROUP BY genre ORDER BY Average_price DESC;

--Exercise 4: "Which 3 books generated the most revenue?"
SELECT b.title, SUM(s.total_price) AS total_revenue, SUM(s.quantity) AS copies_sold FROM books b JOIN sales s ON b.id = s.book_id GROUP BY b.title ORDER BY total_revenue DESC LIMIT 3; 
-- Or knihy_kafe=# SELECT b.title AS book, SUM(s.total_price) AS Most_Revenue_made, SUM(s.quantity) AS Most_copies_sold FROM sales s JOIN books b ON s.book_id = b.id GROUP BY b.title ORDER BY Most_Revenue_made DESC LIMIT 3;

--Exercise 5: "Which customers have made more than 10 purchases?"
SELECT c.name AS customer, COUNT(s.id) AS purchase_count, SUM(s.total_price) AS total_spent FROM customers c JOIN sales s ON c.id = s.customer_id GROUP BY c.name HAVING COUNT(s.id) > 10 ORDER BY purchase_count DESC;

-- Or SELECT c.name AS customer, SUM(s.quantity) AS number_of_purchases FROM sales s JOIN customers c ON s.customer_id = c.id GROUP BY c.name HAVING SUM(s.quantity) > 10 ORDER BY number_of_purchases;

--Exercise 6: "What is the cheapest and most expensive book per author?"
SELECT a.name AS author, MIN(b.price) AS cheapest, MAX(b.price) AS most_expensive, COUNT(b.id) AS books_in_shop FROM authors a JOIN books b ON a.id = b.author_id GROUP BY a.name ORDER BY a.name;

--Or SELECT a.name AS author, STRING_AGG(b.title, ', ' ORDER BY b.price) AS books_cheapest_to_expensive FROM books b JOIN authors a ON b.author_id = a.id GROUP BY a.name ORDER BY a.name;
--Or SELECT a.name AS author, STRING_AGG(b.title || ' (' || b.price::TEXT || ' CZK)', ', ' ORDER BY b.price) AS books_with_prices FROM books b JOIN authors a ON b.author_id = a.id GROUP BY a.name ORDER BY a.name;

--Exercise 7: "Which author had the highest revenue in March 2026?"
SELECT a.name AS author, SUM(s.total_price) AS top_march_revenue FROM sales s JOIN books b ON s.book_id = b.id JOIN authors a ON b.author_id = a.id WHERE s.sale_date BETWEEN '2026-03-01' AND '2026-03-31' GROUP BY a.name ORDER BY top_march_revenue DESC LIMIT 1;

--Or SELECT a.name AS author, SUM(s.quantity) AS copies_sold, COUNT(s.id) AS purchases, SUM(s.total_price) AS Top_March_Revenue FROM sales s JOIN books b ON s.book_id = b.id JOIN authors a ON b.author_id = a.id WHERE s.sale_date BETWEEN '2026-03-01' AND '2026-03-31' GROUP BY a.name  ORDER BY Top_March_Revenue DESC LIMIT 1;

--Exercise 8: "Show each customer's total spending and their percentage of overall revenue."
SELECT
    c.name AS customer,
    SUM(s.total_price) AS total_spent,
    ROUND(
        SUM(s.total_price) * 100.0 / (SELECT SUM(total_price) FROM sales),
        1
    ) AS pct_of_revenue
FROM customers c
JOIN sales s ON c.id = s.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

--Or SELECT c.name AS customer,SUM(s.total_price) AS total_spent, SUM(s.quantity) AS books_purchased, ROUND(SUM(s.total_price) / (SELECT SUM(total_price) FROM sales) * 100, 2) || '%' AS revenue_percentage FROM sales s JOIN customers c ON s.customer_id = c.id GROUP BY c.name ORDER BY total_spent DESC;

--Exercise 9: "How many unique books has each customer purchased?"

SELECT
    c.name AS customer,
    COUNT(DISTINCT s.book_id) AS unique_books,
    COUNT(s.id) AS total_purchases
FROM customers c
JOIN sales s ON c.id = s.customer_id
GROUP BY c.name
ORDER BY unique_books DESC;
-- Or SELECT c.name AS customer, COUNT(DISTINCT book_id) AS unique_books, SUM(s.quantity) AS quantity_purchased, COUNT(s.id) AS number_of_purchases FROM sales s JOIN CUSTOMERS c ON s.customer_id = c.id GROUP BY c.name ORDER BY c.name;

--Exercise 10: "Which genre generates the most revenue per book sold?"


 SELECT
    b.genre,
    SUM(s.total_price) AS total_revenue,
    COUNT(s.id) AS total_sales,
    ROUND(SUM(s.total_price) / COUNT(s.id), 2) AS revenue_per_sale
FROM sales s
JOIN books b ON s.book_id = b.id
GROUP BY b.genre
ORDER BY revenue_per_sale DESC;

--Exercise 11: "Show all authors — including those with zero sales — with their total revenue."

SELECT a.name AS author, SUM(s.quantity) AS copies_sold, COUNT(s.id) AS sales_made, COALESCE(SUM(s.total_price), 0) AS total_revenue FROM sales s LEFT JOIN books b ON s.book_id = b.id LEFT JOIN authors a ON b.author_id = a.id  GROUP BY a.name ORDER BY total_revenue DESC;

--Exercise 12: "For each month, show the best-selling book (by revenue)."
SELECT DISTINCT ON (month)
    DATE_TRUNC('month', s.sale_date)::DATE AS month,
    b.title,
    SUM(s.total_price) AS top_revenue
FROM sales s
JOIN books b ON s.book_id = b.id
GROUP BY DATE_TRUNC('month', s.sale_date), b.title
ORDER BY month, top_revenue DESC;

--SELECT DISTINCT ON (month) b.title AS best_selling_book, SUM(s.quantity) AS copies_sold, SUM(s.total_price) AS top_revenue_earned, COUNT(s.id) AS purchases_made, DATE_TRUNC('MONTH', s.sale_date)::DATE AS month FROM sales s JOIN books b ON s.book_id = b.id GROUP BY b.title, DATE_TRUNC('MONTH',s.sale_date) ORDER BY top_revenue_earned DESC;


--Exercise 13: "Create a customer loyalty summary: name, city, total purchases, total spent, average purchase value, and first and last purchase dates."

SELECT 
    c.name,
    c.city,
    COUNT(s.id) AS total_purchases,
    SUM(s.total_price) AS total_spent,
    ROUND(AVG(s.total_price), 2) AS avg_purchase,
    MIN(s.sale_date) AS first_purchase,
    MAX(s.sale_date) AS last_purchase
FROM customers c
JOIN sales s ON c.id = s.customer_id
GROUP BY c.name, c.city
ORDER BY total_spent DESC;


