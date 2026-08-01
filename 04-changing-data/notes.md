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

