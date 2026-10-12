## What a window function does
- A window function calculates across rows without collapsing them, while GROUP BY collapses many rows into one row per group.

## The three ranking functions
- ROW_NUMBER — always unique; add a unique tie-breaker column so ties come out in a stable order
- RANK — ties share a number, next number skips
- DENSE_RANK — ties share a number, next number continues

## LAG and LEAD
- LAG gives the value from the previous row, so I can compare it with the current row without collapsing rows. Example: `LAG(daily_revenue) OVER (ORDER BY sale_date)`.
- LEAD does the same with the next row.
- A moving average is a different thing: `AVG(SUM(total_price)) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` averages the last 7 rows (days that had sales). `RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW` averages the last 7 calendar days, and it crosses month boundaries unless I partition by month.

## OVER() cheat sheet
- Empty OVER () = all rows; PARTITION BY = per group; ORDER BY = running total up to the current row (for SUM, AVG, COUNT).

## The 5 interview patterns I practised
1. Top N per group — ROW_NUMBER + PARTITION BY
2. Period-over-period — LAG
3. Running total — SUM OVER ORDER BY
4. Ranking with ties — RANK / DENSE_RANK
5. Consecutive events — LAG with date arithmetic

## Self check
### 1. Explain window functions to someone who only knows GROUP BY
GROUP BY collapses many rows into one row per group, like a summary report with one line per class. A window function keeps every row and adds a calculation based on the group it belongs to, like a register that lists every student with the class average next to each name. Each row belongs to a group (the "partition"), and the calculation is done within that group while the row stays intact.

### 2. Exercise 7: the big dashboard query, walked through

Overview: the query builds one row per author in three steps. `author_rank` calculates revenue, rank, percentage and unique customers per author. `book_revenue` and `best_selling` pick each author's top book by revenue with `ROW_NUMBER` and a filter. The final `SELECT` joins them on `author_id`.

```sql
WITH author_rank AS (  -- CTE 1: one row per author
    SELECT a.id AS author_id, a.name AS author, -- a.id keeps authors with the same name separate, and is the join key used at the end
           SUM(s.total_price) AS total_revenue, -- adds up all of the author's sales
           COUNT(DISTINCT s.customer_id) AS unique_customers, -- counts each customer once, however many times they bought
           DENSE_RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS rank_revenue, -- ranks the grouped authors by revenue, ties share a rank, no numbers skipped
           ROUND(SUM(s.total_price) / SUM(SUM(s.total_price)) OVER () * 100, 2) || '%' AS percentage_total_revenue -- author's revenue / sum of all authors' revenue * 100, rounded to 2 decimals, then % added as text for display only
    FROM sales s -- the query starts here: sales is the base table
    JOIN books b ON s.book_id = b.id -- match each sale to its book
    JOIN authors a ON b.author_id = a.id -- match each book to its author
    GROUP BY a.id, a.name -- collapses the sales into one row per author
),
book_revenue AS ( -- CTE 2: one row per author and book, numbered by revenue
    SELECT a.id AS author_id, b.title, -- keep the author id (for the join later) and the title
           ROW_NUMBER() OVER (PARTITION BY a.id ORDER BY SUM(s.total_price) DESC, b.id) AS rn -- runs after GROUP BY, so it can use SUM; numbers each author's books from highest revenue as 1; PARTITION BY restarts the numbering for each author; b.id is the tie-breaker so there is always exactly one rn = 1
    FROM sales s
    JOIN books b ON s.book_id = b.id
    JOIN authors a ON b.author_id = a.id
    GROUP BY a.id, b.id, b.title -- one row per author and book; b.id keeps two books with the same title separate
),
best_selling AS ( -- CTE 3: only each author's top book
    SELECT author_id, title AS best_selling_book -- author_id and title come from book_revenue
    FROM book_revenue
    WHERE rn = 1 -- WHERE can't filter a window result in the same query, so it is done here, in the next layer
)
SELECT ar.author, ar.total_revenue, ar.rank_revenue,
       ar.percentage_total_revenue, ar.unique_customers, bs.best_selling_book -- final columns from the two CTEs
FROM author_rank ar
JOIN best_selling bs ON ar.author_id = bs.author_id -- the two CTEs are matched on author_id, which they share
ORDER BY ar.rank_revenue, ar.author; -- highest revenue first, then author name for ties
```

### 3. Hardest pattern: Top N per group
Structure:
1. CTE: calculate the metric per row (or per group with GROUP BY), then
   `ROW_NUMBER() OVER (PARTITION BY group_col ORDER BY metric DESC, unique_col)`
   — keep the group's id as its own column (needed later for joining).
2. Filter in an outer query or a second CTE: `WHERE rn <= N` (a window result can't be filtered in the same query's WHERE, because WHERE runs before window functions).
3. If I need other data per group (like author revenue), join on the group id.

What confused me: when GROUP BY is already in the CTE, each row is already one group (no PARTITION BY needed for ranking across them); PARTITION BY is only for restarting inside a bigger group.

## The query I'm most proud of from this chapter

Cumulative number of unique books sold over time:

```sql
WITH first_sale AS (
    SELECT book_id, MIN(sale_date) AS first_sale_date
    FROM sales
    GROUP BY book_id
)
SELECT first_sale_date,
       COUNT(*) AS new_books,
       SUM(COUNT(*)) OVER (ORDER BY first_sale_date) AS cumulative_unique_books
FROM first_sale
GROUP BY first_sale_date
ORDER BY first_sale_date;
```

I solved the exercises with several attempts on my own by running incorrect versions in the shell until I reached the correct one. For this query I checked the last row against `SELECT COUNT(DISTINCT book_id) FROM sales`, and both gave 14.