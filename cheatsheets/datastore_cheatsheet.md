# DATASTORES
- for postgres see [postgres](postgres_cheatsheet.md)


## RELATIONAL
- cardinality - the amount of unique values in a column relative to the table size
    - boolean column only has 2 unique values, super low cardinality
- tablespace vs schema - https://stackoverflow.com/questions/35120219/a-database-schema-vs-a-database-tablespace
- transactional DDL - can rollback DDLs like transactional DMLs
    - rolloback whole table creations even
### SQL
- joins - query that joins two tables
    - inner join - (left or right), will only return records with hits
    - outer join - will return all records in both tables
- subquery - query executed first and results used in outer query
- corelated subquery - nested select statement, where inner select logic refers to outer select logic
    - so essentially running the inner select for each line of the outer select
### INDEXES
- BTREE tree is the most common index type
    - great for `<`, `>`, `=` on primitve data types
### DOCS
- https://use-the-index-luke.com/

## LOCKS
- pessimistic vs optimistic
    - pessimistic -> aquire expclit locks, e.g. strict two-phase locking (2PL)
    - optimistic -> assume conflicts wont occur, check if so at end and then cancel/rollback if conflict did occur
        - postgres MVCC is optimistic

## ACID
- Atomicity
- Consistency
- Isolation
- Durability

## GRAPH
- Neo4j - most established and well known

## SQLLITE
- `.quit` - exit the sql client
- `.tables` - list tables
- `.schema footable` - get a table's description
- `.mode line` - display each records column in seperate line
