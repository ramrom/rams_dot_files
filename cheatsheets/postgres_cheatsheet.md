# POSTGRES

## PSQL
- `\?` output help menu
- `\c` to connect to database
- `\l` to list database
- `\dn` to list all schemas
- `\dt` to list all tables
- `\d sometable` to describe a table
- `\o somefile` output to a file
- `\i somefile` execute commands from a file

## CONCEPTS
- table partitioning - creating a logical table backed by many physical tables
    - in postgres 11 foreign tables can be attached to table partitions
- foreign table - a logical table that queries data from an external source
    - foreign data wrapper will fetch external data
- views - a virtual table, which is a stored query which can itelf be queries against
    - materialized view - a view that contains the results of a query
        - it's a type of caching of a query
- locks
    - table lock vs row lock
    - common
        - access share - anyone can read on table, cant write to table
        - row share, row exclusive
    - advisory lock - server doesnt enforce anything, this is to let application clients know and handle sync
    - optimistic vs pessimistic
        - pessimistic is explicitly locking for exclusive use
        - optimistic compares version nums at beginning of transaction and compares it at the end to see if it changed
            - rollback/re-try if it changed
            - often used when application can't have a persistent db connection to explicit/pessimistic lock

## SPECIAL TABLES
- https://www.postgresql.org/docs/current/monitoring-stats.html
    - `pg_stat_activity` a view that shows queries running per process
- `pg_locks` a view that shows locks owned by various processes and transactions
