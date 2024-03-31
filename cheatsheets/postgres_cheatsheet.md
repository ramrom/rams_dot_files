# POSTGRES
- also see [datastore](datastore_cheatsheet.md)
- decent blog on postgres jsonb vs mongodb
    - https://medium.com/@yurexus/can-postgresql-with-its-jsonb-column-type-replace-mongodb-30dc7feffaf3

## TYPES
- `json` - same as varchar or string, but enforces it's a valid json string
- `jsonb` - binary format of json, takes more time to store, but you can build indexes on it
    - postgres team was looking at mongodb `bson` but went with their own instead

## INDEXES
- BTREE
- GIN - generalized inverted index
- GIST

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
    - foreign data wrapper(FDW) will fetch external data
- views - a virtual table, which is a stored query which can itelf be queries against
    - materialized view - a view that contains the results of a query
        - it's a type of caching of a query
        - can combine a matrialized view and foreign table
- MVCC - multi-version concurrency control
    - each transaction gets it's own isolation view of the database
    - more similar to optimistic locking where each transaction doesn't directly block others
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
- when a transaction is commited, WAL transactions are written

## SCALING
- table partitioning(sharding) - each partition contains a subset of rows
    - horizontal method: create table partitions on other servers and use FDWs to represent the logical table
    - vertical method: create a partition on different tablespaces (on different disks)
- read replicas - for just read queries, a replica can be made hot standby
- multi-master (active-active) setup
    - has eventual data consistency
    - bi-direction replication, changes made to one master are replicated to other masters

## REPLICATION
- two major types: logical and physical
### PHYSICAL REPLICATION
- low level storage data (exact block address, byte-by-byte) is sync'd to replicas
- disadvantage: must replicate all data in the db
- basic process
    - SQL statements are run on a master
    - this generates WAL(write-ahead-log) records
    - read replicas read the WAL records and replay them, so they have a copy of master
    - log shipping is most often done with streaming, but can be logical too
- warm standby means a replica that is only available for hot swapping when master dies
- hot standby means a replica can be queried with reads
### LOGICAL REPLICATION
- high level SQL statements are sync'd to replicas
- advantage: can control which tables and data get replicated
- uses a pub/sub model to replicate
    - WAL transactions are decoded and then published

## QUERY TIPS
- counting num records in db table
    - `select count(1) from footable;` - for big table, slow but accurate
    - https://stackoverflow.com/questions/7943233/fast-way-to-discover-the-row-count-of-a-table-in-postgresql
        - `SELECT reltuples AS estimate FROM pg_class where relname = 'mytable';` - fast but somewhat innaccurate
        - `SELECT reltuples::bigint AS estimate FROM pg_class WHERE  oid = 'myschema.mytable'::regclass;` - better

## SPECIAL TABLES
- https://www.postgresql.org/docs/current/monitoring-stats.html
    - `pg_stat_activity` a view that shows queries running per process
- `pg_locks` a view that shows locks owned by various processes and transactions
- `pg_stat_progress_create_index` - show status of index creation
