--Exercise 1 — Price increase
--Increase the price of all books with more than 500 pages by 15%. 
--Use RETURNING to show what changed.
SELECT title, price, pages FROM books WHERE pages > 500;--PREVIEW
BEGIN;--Begining of the transaction
UPDATE books SET price = ROUND(price*1.15,2) WHERE pages>500 RETURNING title, price, pages;--Uncommited transaction
--Table updated and returning clause has verified the changes
--ROLLBACK;-- changes made in transaction is reversed
COMMIT; --Transaction has been commited which means changes made so far are permanantly stored in the table

--Exercise 2 — Out of stock
--Mark all books published before 1930 as out of stock.
-- Use RETURNING to confirm.
SELECT title, published_date, in_stock FROM books WHERE published_date < '01-01-1930' ORDER BY published_date DESC;
BEGIN;
UPDATE books SET in_stock = FALSE WHERE published_date < '01-01-1930' RETURNING title, published_date, in_stock ORDER BY published_date DESC;
COMMIT;

--Exercise 3 — Fixing a mistake with ROLLBACK 
--Start a transaction, set all prices to 1.00 (simulating a mistake),
-- verify the damage with SELECT, then ROLLBACK to undo it. 
--Verify that the original prices are restored.
SELECT title, price FROM books WHERE price IS NOT NULL;
BEGIN; 
UPDATE books SET price = 1.00 WHERE price IS NOT NULL RETURNING title, price;
ROLLBACK;
SELECT title, price FROM books;

--Exercise 4 — Updating with a calculation
--The Czech crown weakened. Convert all prices from CZK to a 3% increase and round to whole numbers (0 decimal places).
SELECT title, price FROM books;
BEGIN;
UPDATE books SET price = ROUND(price*1.03,0) WHERE price IS NOT NULL RETURNING title, price AS new_price;
COMMIT;

--Exercise 5 — Targeted DELETE
--Delete the book "Apocryphal Tales" (a Čapek book we added in Chapter 3). Use RETURNING to see what was deleted.
SELECT title FROM books;
BEGIN;
DELETE FROM books WHERE title = 'Apocryphal Tales' RETURNING INITCAP(title);
ROLLBACK;

--Exercise 6 — Multi-step transaction
--In one transaction: (a) increase all fiction books by 10%, 
--(b) set all non-fiction books as out of stock,
--(c) verify both changes, (d) commit if correct.
SELECT title, price, in_stock, genre FROM books;
BEGIN;
UPDATE books SET price = ROUND(price*1.1,2) WHERE genre = 'fiction' RETURNING title, price, genre; 
UPDATE books SET in_stock = FALSE WHERE genre = 'non-fiction' RETURNING title, in_stock, genre;
SELECT title, price, genre, in_stock FROM books ORDER BY genre, title;
COMMIT;

--Exercise 7 — Updating with data from the same table
--Set the price of the cheapest book to match the price of the second cheapest book.
--(This was harder)
SELECT title, price FROM books ORDER BY price LIMIT 2;
--here i checked the price of first two cheapest books xD i kept using MIN() function .
BEGIN;
UPDATE books SET price = (SELECT price FROM books ORDER BY price LIMIT 1 OFFSET 1) WHERE id = (SELECT id FROM books ORDER BY price LIMIT 1) RETURNING title, price ;
--Okay i got the first part where i set the price to the cheapeast book this was simple but then the where clause is what ticked me off yes its simple and easy we always have to write where clause what the hell my skills are terrible than i thought well not too terrible i can work on it and be smarter D:
COMMIT;