# DATASTORES
- for postgres see [postgres](postgres_cheatsheet.md)

## RELATIONAL
- cardinality - the amount of unique values in a column relative to the table size
    - boolean column only has 2 unique values, super low cardinality
- tablespace vs schema - https://stackoverflow.com/questions/35120219/a-database-schema-vs-a-database-tablespace
- transactional DDL - can rollback DDLs like transactional DMLs
    - rolloback whole table creations even

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
