
--Exercise 3: "Create a view called `book_sales_summary` that shows each book's title, author, total copies sold, and total revenue.

CREATE VIEW book_sales_summary AS
SELECT
    b.title,
    a.name AS author,
    COALESCE(SUM(s.quantity), 0) AS copies_sold,
    COALESCE(SUM(s.total_price), 0) AS total_revenue
FROM books b
JOIN authors a ON b.author_id = a.id
LEFT JOIN sales s ON b.id = s.book_id
GROUP BY b.title, a.name;


--Create a view called `monthly_dashboard` that shows month, total revenue, number of sales, unique customers, and unique books sold.

CREATE VIEW monthly_dashboard AS
SELECT
    DATE_TRUNC('month', s.sale_date)::DATE AS month,
    SUM(s.total_price) AS revenue,
    COUNT(s.id) AS total_sales,
    COUNT(DISTINCT s.customer_id) AS unique_customers,
    COUNT(DISTINCT s.book_id) AS unique_books
FROM sales s
GROUP BY DATE_TRUNC('month', s.sale_date) ORDER BY revenue DESC;