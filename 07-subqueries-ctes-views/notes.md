# Chapter 7 — subqueries, CTEs, views — advanced query organisation

## Show each month's revenue and how it compares to the previous month. Explain Monthly revenue with running comparison using CTEs.
```sql
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', sale_date)::DATE AS month,
        SUM(total_price) AS revenue
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)
    ORDER BY month
)
SELECT
    m1.month,
    m1.revenue,
    m2.revenue AS prev_month_revenue,
    ROUND(m1.revenue - COALESCE(m2.revenue, 0), 2) AS change
FROM monthly m1
LEFT JOIN monthly m2
    ON m1.month = m2.month + INTERVAL '1 month'
ORDER BY m1.month;
```
- WITH is a keyword used to create a CTE. monthly is the name assigned to this CTE. AS introduces the CTE definition.
- The CTE block starts from ( and ends at ). Inside it we have the aggregate function SUM() and the DATE_TRUNC function.
- DATE_TRUNC('month', sale_date)::DATE truncates the sale date to the first day of each month and casts it to a DATE type so each month is displayed as a clean date like 2026-01-01.
- SUM(total_price) adds all total_price values and displays the result using the alias revenue.
- sale_date and total_price are columns in the sales table which is why we reference it in FROM sales.
- GROUP BY DATE_TRUNC('month', sale_date) groups all sales from the same month into one row so SUM() can calculate monthly totals.
- The main SELECT references the CTE twice — as m1 (current month) and m2 (previous month). LEFT JOIN is used because January has no previous month in our data — without it January would be excluded from results entirely.
- m1.month = m2.month + INTERVAL '1 month' means: find the row in m2 where m2 is exactly 1 month before m1. This links each month to its previous month.
- The SELECT outputs four columns: m1.month (current month), m1.revenue (current revenue), m2.revenue AS prev_month_revenue (previous month revenue), and change (the difference).
- COALESCE(m2.revenue, 0) replaces NULL with 0 for January since there is no December 2025 data in the database. This prevents the subtraction from failing on NULL.
- ROUND(..., 2) rounds the difference to 2 decimal places and displays it as the change column.
- Finally ORDER BY m1.month arranges the output in ascending order from January to May.

## what is the difference between a view and a table?

- A table physically stores data on disk — every row and column is saved in the database and persists until deleted. A table is where the actual data lives.
- A view does not store data. It stores a saved query that runs every time you SELECT from it. The result looks like a table but it is generated fresh each time from the underlying tables.
- If someone said "a view is just a table" I would correct them by saying: a view is a saved question, not saved data. When you query a view, PostgreSQL runs the original query behind it and returns the result. If the underlying table data changes, the view reflects those changes automatically — because it never stored the old data in the first place.
- The exception is a materialised view which does store data physically like a table, but requires a manual REFRESH MATERIALIZED VIEW to update when the underlying data changes.

## CREATE A VIEW named as unsold_books and display title of each of these unsold books along with the column as copies_sold as 0.
```sql

CREATE VIEW unsold_books AS
SELECT 
    b.title AS title,
    0 AS copies_sold
FROM books b
LEFT JOIN sales s ON b.id = s.book_id
WHERE s.id IS NULL
ORDER BY b.title;
```

## CREATE A VIEW books that are out of stock but have sold more than 5 copies
```sql
CREATE VIEW low_stock_report AS
SELECT 
    b.title,
    a.name AS author,
    b.price,
    COALESCE(SUM(s.quantity), 0) AS total_sold,
    b.in_stock
FROM books b
JOIN authors a ON b.author_id = a.id
LEFT JOIN sales s ON b.id = s.book_id
GROUP BY b.title, a.name, b.price, b.in_stock
HAVING COALESCE(SUM(s.quantity), 0) > 5 AND b.in_stock = FALSE
ORDER BY total_sold DESC;


```