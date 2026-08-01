## Chapter-4: Changing Data Safely

## Knihy a Kafe bookshop - UPDATE, DELETE, transactions

## Every change uses the safety workflow:
- 1.SELECT TO preview
- 2. BEGIN transaction
- 3. UPDATE/DELETE with RETURNING
- 4. COMMIT or ROLLBACK

## Key commands 
- UPDATE ... SET ... WHERE - changes values in existing rows
- DELETE FROM ... WHERE - removes rows
- BEGIN / COMMIT / ROLLBACK - transaction control
- RETURNING - shows what was just changed

## Most important lesson
Always UPDATE or DELETE inside a transaction when unsure of results — 
wrong changes can be rolled back before committing. Back up your SQL 
files on GitHub so even if you DROP a table accidentally, you can 
rebuild it from your saved scripts.

## Answering my own thoughts
- 1. Write out the safety workflow step by step, as if creating instructions for someone who has never used SQL.
- Use Select statement with a WHERE clause before beginning our transactions to preview the unverified updates.
- BEGIN a transaction then UPDATE the table and SET its columns values with WHERE clause then use RETURNING to verify our results.
- Once satisfied use COMMIT to finalise our results if not just use ROLLBACK to revert the changes. 
- 2. Describe a scenario where a transaction with ROLLBACK would save you from disaster. Make up a realistic example.
- Example : If i was writing a books with a pencil without a eraser i cannot go erase the mistakes i did while writing a sentence and correct the errors . So bascially ROLLBACK is a eraser which we can use to reverse the uncommited transactions.
- Example -2: Imagine updating all book prices for a 10% discount but forgetting the WHERE clause — every book in the table gets discounted instead 
  of just fiction books. ROLLBACK inside a transaction saves you from committing that mistake permanently.
- 3. What is the difference between RETURNING and running a separate SELECT after the UPDATE? When would RETURNING not be enough and you'd want a full SELECT?
- RETURNING is a shortcut for writing a seperate SELECT statement after an update to verify our result.RETURNING only shows the rows that were just changed. 
  A full SELECT is needed when you want to see ALL rows in context — for example checking that unchanged rows weren't accidentally affected, 
  or verifying the overall state of the table after the update.