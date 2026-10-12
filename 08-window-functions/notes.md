## What a window function does
- A window function calculates across rows without collapsing them, while GROUP BY collapses many rows into one row per group.

## The three ranking functions
- ROW_NUMBER — always unique; add a unique tie-breaker column so ties come out in a stable order
- RANK — ties share a number, next number skips
- DENSE_RANK — ties share a number, next number continues

## LAG and LEAD
- LAG gives the value from the previous row, so I can compare it with the current row without collapsing rows. Example: `LAG(daily_revenue) OVER (ORDER BY sale_date)`.
- LEAD does the same with the next row.
- A moving average is a different thing: `AVG(SUM(total_price)) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` averages the last 7 rows. `RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW` averages the last 7 calendar days, and it crosses month boundaries unless I partition by month.

## OVER() cheat sheet
- Empty OVER () = all rows; PARTITION BY = per group; ORDER BY = running total up to the current row.

## The 5 interview patterns I practised
1. Top N per group — ROW_NUMBER + PARTITION BY
2. Period-over-period — LAG
3. Running total — SUM OVER ORDER BY
4. Ranking with ties — RANK / DENSE_RANK
5. Consecutive events — LAG with date arithmetic

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