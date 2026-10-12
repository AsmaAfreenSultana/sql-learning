--Exercise 1: "Rank all books by price, highest first. Show title, price, and rank.
SELECT title, price, RANK() OVER (ORDER BY price DESC) AS rank
FROM books
ORDER BY price DESC, title;
--Notice no tiebreaker is needed for rank as the rank for same books are in same number while the next book takes the position after the book which was supposed to be ranked before it when it comes to Row_Number yes we need a tie breaker in such case i would add b.id inside window function in the end .

--Exercise 2 : "For each genre, show the most and least expensive book."

WITH rank_book AS ( SELECT title, genre, price, ROW_NUMBER() OVER(PARTITION BY genre ORDER BY price DESC, id) AS high_rank, ROW_NUMBER() OVER(PARTITION BY genre ORDER BY price, id) AS low_rank FROM books) SELECT hi.title AS most_expensive_book, hi.genre, hi.price AS expensive_price, lo.title AS least_expensive, lo.price AS cheapeast_price FROM rank_book hi JOIN rank_book lo ON hi.genre = lo.genre WHERE hi.high_rank = 1 AND lo.low_rank = 1 ORDER BY hi.genre;

--kept here id of books as who knows in future i might have duplicate titles with different authors 
-- Solution -2: i did this by going through past chapters again. SELECT hi.genre, hi.title AS most_expensive_book, hi.price AS expensive, lo.title AS cheapeast_book, lo.price AS cheapest_price FROM ( SELECT DISTINCT ON(genre) genre, title, price FROM books ORDER BY genre, price DESC, id) hi JOIN (SELECT DISTINCT ON (genre) genre, title, price FROM books ORDER BY genre, price, id) lo ON hi.genre = lo.genre ORDER BY hi.genre;
-- Solution - 3 : This was in the notes with case which i didnt like it. even though one might argue its easiest i dont see the result in proper order which i displayed in earlier solutions. WITH ranked AS ( SELECT title, genre, price, ROW_NUMBER() OVER(PARTITION BY genre ORDER BY price DESC, id) AS high_rank, ROW_NUMBER() OVER(PARTITION BY genre ORDER BY price, id) AS low_rank FROM books) SELECT genre, title, price, CASE WHEN high_rank = 1 THEN 'Most expensive' WHEN low_rank = 1 THEN 'least expensive' END AS label FROM ranked WHERE high_rank = 1 OR low_rank = 1 ORDER BY genra, price DESC;
-- Solution -4: since i was thinking about subqueries i tried to do this way as well was a bit complicated but then i did it. WITH rank_book AS ( SELECT title, genre, price, ROW_NUMBER() OVER(PARTITION BY genre ORDER BY price DESC, id) AS high_rank, ROW_NUMBER() OVER(PARTITION BY genre ORDER BY price, id) AS low_rank FROM books) SELECT r.genre, r.title AS most_expensive_book, r.price  AS expensive_price, (SELECT l.title FROM rank_book l WHERE l.title = r.genre AND l.low_rank = 1) AS cheapeast_book, (SELECT l.price FROM rank_book l WHERE l.genre = r.genre AND l.low_rank = 1 ) AS cheapeast_price FROM rank_book r WHERE r.high_rank = 1 ORDER BY r.genre;  


--Exercise 3: "Show daily revenue with a 7-day moving average."

 WITH daily AS (SELECT s.sale_date AS day, SUM(s.total_price) AS daily_revenue, ROUND(AVG(SUM(s.total_price)) OVER( ORDER BY s.sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS week_moving_average FROM sales s GROUP BY s.sale_date) SELECT * FROM daily ORDER BY day;

--Solution -2: WITH daily AS (SELECT s.sale_date AS day, SUM(s.total_price) AS daily_revenue, ROUND(AVG(SUM(s.total_price)) OVER( ORDER BY s.sale_date RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW), 2) AS week_moving_average FROM sales s GROUP BY s.sale_date) SELECT * FROM daily ORDER BY day; this version i found more accurate as it strictly follows the calendar in case we have sales gaps in case we might not have sales on particular day so revenue for that day will be zero this means the average will be 6-1 which is 5 days so we are averaging for 5 days in such cases.


--Exercise 4: "For each sale, show what percentage it represents of its month's total revenue."
SELECT id, sale_date AS date, total_price, SUM(total_price) OVER(PARTITION BY DATE_TRUNC('month', sale_date)) AS month_revenue, ROUND(total_price/(SUM(total_price) OVER(PARTITION BY DATE_TRUNC('month', sale_date)))*100, 2)|| '%' AS revenue_percentage_month FROM sales ORDER BY sale_date, id;

--Solution-2 : WITH month_revenue AS ( SELECT DATE_TRUNC('month', sale_date)::DATE AS month, SUM(total_price) AS month_revenue FROM sales GROUP BY DATE_TRUNC('month', sale_date) )SELECT sale_date, total_price, ROUND((total_price/mr.month_revenue)*100,2) ||' %' AS sale_percentage, mr.month_revenue FROM sales  JOIN month_revenue mr ON DATE_TRUNC('month', sale_date)::DATE = mr.month ORDER BY sale_date, id;
--Solution-3 : SELECT sale_date, total_price, ROUND( total_price / SUM(total_price) OVER (PARTITION BY DATE_TRUNC('month', sale_date)::DATE) * 100, 2 )||' %' AS sale_percentage, SUM(total_price) OVER(PARTITION BY DATE_TRUNC('month', sale_date)::DATE) AS month_revenue FROM sales ORDER BY sale_date, id; i skipped type cast as the expression is hidden

--Exercise 5: "Show each customer's purchases numbered in order (1st purchase, 2nd purchase, etc.)."

WITH cust_purchases AS ( SELECT c.id AS customer_id, c.name AS customer, s.total_price AS price, s.sale_date AS date, DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.sale_date, s.id) AS purchase_list FROM sales s JOIN customers c ON s.customer_id = c.id ) SELECT CASE WHEN purchase_list = 1 THEN customer END AS customer, date, purchase_list, price FROM cust_purchases ORDER BY customer_id, purchase_list;

--Solution -2: did this while reading although the one i wrote above is right one cause i want the purchases made on same day counted separately hence the tie breaker with DENSE_RANK() funtion. well even this one creates no differance WITH numbered AS (    SELECT        c.id AS customer_id,        c.name AS customer,        s.sale_date AS date,        s.total_price AS purchase_price,        ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY s.sale_date, s.id) AS purchase_num    FROM sales s    JOIN customers c ON s.customer_id = c.id)SELECT    CASE WHEN purchase_num = 1 THEN customer END AS customer,    date,    purchase_price,    purchase_num FROM numbered ORDER BY customer_id, purchase_num;

--Exercise 6: "Calculate the cumulative number of unique books sold over time." 

WITH book_count AS ( SELECT book_id, MIN(sale_date) AS first_sale_date FROM sales   
GROUP BY book_id)SELECT first_sale_date, COUNT(*) AS new_books, SUM(COUNT(first_sale_date)) OVER( ORDER BY FIRST_SALE_DATE ) AS cumulative_unique_books FROM book_count GROUP BY first_sale_date ORDER BY first_sale_date;

-- Solution -2: SELECT b.title, MIN(s.sale_date) AS first_sale_date, ROW_NUMBER() OVER (ORDER BY MIN(s.sale_date), b.id) AS unique_books_so_far FROM sales s JOIN books b ON s.book_id = b.id GROUP BY b.id, b.title ORDER BY first_sale_date, b.id;

--Exercise 7: "The Big Dashboard Query — for each author, show: total revenue, rank by revenue, percentage of total shop revenue, number of unique customers, and their best-selling book title."

WITH author_rank AS (
    SELECT a.id AS author_id, a.name AS author,
           SUM(s.total_price) AS total_revenue,
           COUNT(DISTINCT s.customer_id) AS unique_customers,
           DENSE_RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS rank_revenue,
           ROUND(SUM(s.total_price) / SUM(SUM(s.total_price)) OVER () * 100, 2) AS percentage_total_revenue
    FROM sales s
    JOIN books b ON s.book_id = b.id
    JOIN authors a ON b.author_id = a.id
    GROUP BY a.id, a.name
),
book_revenue AS (
    SELECT a.id AS author_id, b.title,
           ROW_NUMBER() OVER (PARTITION BY a.id ORDER BY SUM(s.total_price) DESC, b.id) AS rn
    FROM sales s
    JOIN books b ON s.book_id = b.id
    JOIN authors a ON b.author_id = a.id
    GROUP BY a.id, b.id, b.title
),
best_selling AS (
    SELECT author_id, title AS best_selling_book
    FROM book_revenue
    WHERE rn = 1
)
SELECT ar.author, ar.total_revenue, ar.rank_revenue,
       ar.percentage_total_revenue, ar.unique_customers, bs.best_selling_book
FROM author_rank ar
JOIN best_selling bs ON ar.author_id = bs.author_id
ORDER BY ar.rank_revenue, ar.author;
--Solution -2: WITH author_stats AS (    SELECT        a.id AS author_id,        a.name AS author,        SUM(s.total_price) AS revenue,        COUNT(DISTINCT s.customer_id) AS unique_customers,        COUNT(s.id) AS total_sales    FROM authors a    JOIN books b ON a.id = b.author_id    JOIN sales s ON b.id = s.book_id    GROUP BY a.id, a.name),book_revenue AS (    SELECT        b.author_id,        b.title,        SUM(s.total_price) AS book_rev,        ROW_NUMBER() OVER (            PARTITION BY b.author_id            ORDER BY SUM(s.total_price) DESC        ) AS rn    FROM books b    JOIN sales s ON b.id = s.book_id    GROUP BY b.author_id, b.title),shop_total AS (    SELECT SUM(total_price) AS total FROM sales)SELECT    ast.author,    ast.revenue,    RANK() OVER (ORDER BY ast.revenue DESC) AS revenue_rank,    ROUND(ast.revenue * 100.0 / st.total, 1) AS pct_of_shop,    ast.unique_customers,    br.title AS best_selling_book FROM author_stats ast JOIN book_revenue br ON ast.author_id = br.author_id AND br.rn =1--CROSS JOIN shop_total st ORDER BY ast.revenue DESC;