# Chapter 6 — Aggregation and Grouping

## The five aggregate functions
- COUNT — counts rows
- SUM — adds values
- AVG — calculates mean
- MIN — finds smallest
- MAX — finds largest

## WHERE vs HAVING — in my own words
- WHERE is used to filter columns of the table where as HAVING is used to filter aggregated groups 
- WHERE filters rows BEFORE grouping — it works on individual row values.
- HAVING filters AFTER grouping — it works on aggregated values like 
SUM, COUNT, AVG.
- Example:
```sql
WHERE price > 300        -- filters individual book prices before grouping
HAVING SUM(price) > 300  -- filters groups whose total exceeds 300
```

## COUNT(*) vs COUNT(column) vs COUNT(DISTINCT column)
- COUNT(*) counts all the rows within a table including NULLs.
- COUNT(column) counts all the rows within the given column. it doesn't count NULL values
- COUNT(DISTINCT column) counts all the unique rows with in a column ignores NULLs.

## Three business questions I answered with SQL
1. "Which of our authors is the most profitable?" → (Yes this one i was somehow able to do it correctly)
2. "Are sales growing or shrinking month over month?" → (This question is similar to exercise 2 )
3. "Which city has the most engaged customers?" → Prague dominates with 4 out of 7 customers, generating the most total revenue.

## This chapter's biggest insight

I did all the exercises correctly except 1 which was exercise 12 where i needed to add DISTINCT ON (month). This chapter felt like a turning point — I could see how SQL 
answers real business questions, not just retrieve data.

-why is this chapter the transition from "database user" to "analyst"?
-Earlier chapters were about data entry and retrieval — inserting, updating, and filtering rows. Chapter 6 is where SQL became a tool for answering real business questions. For the first time I could 
calculate total revenue, identify the most profitable authors, see which books were popular, and understand each customer's contribution to the business. That shift from retrieving data to analysing it is 
what makes this chapter the transition from database user to analyst.