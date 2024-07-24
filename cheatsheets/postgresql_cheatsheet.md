# POSTGRESQL
- also see [datastore](datastore_cheatsheet.md)
- decent blog on postgres jsonb vs mongodb
    - https://medium.com/@yurexus/can-postgresql-with-its-jsonb-column-type-replace-mongodb-30dc7feffaf3

## HISTORY
- ver7.1 (release 2010)
    - WAL introduced
- ver8.0 (release 2005) - point-in-time recovery
- ver8.3 (release 2008) - pg_standby
- ver9.0 (release 2010) - hot standby, streaming replication
- ver9.1 (release 2011) - sync replication, pg_basebackup
- ver9.2 (release 2012) - cascading replication
- ver9.4 (release 2014) - replication slots, logical decoding(building blocks for logical replication)
- ver10 (release 2022?) - full logical replication

## TYPES
- `text` - unbounded string
- `json` - same as varchar or text, but enforces it's a valid json string
- `jsonb` - binary format of json, takes more time to store, but you can build indexes on it
    - postgres team was looking at mongodb `bson` but went with their own instead

## INDEXES
### CORE TYPES
- BTREE
- HASH
- GIN - generalized inverted index
- GIST - generalized search trees
- SP-GIST - space partitioned GIST
- BRIN - block ranged index
### FEATURE
- expression - index based on result of expression/function, and not just value of a column
- partial - only index some rows, usually specified by a WHERE clause

## PSQL
- `\conninfo` - get db name, user name, host IP, port #, SSL info
- `select version();` - get postgres server version, host arch/os
- `\?` output help menu
- `\c` to connect to database
- `\l` to list database
- `\dn` to list all schemas
- `\dt` to list all tables
- `\d sometable` to describe a table
- `\o somefile` output to a file
- `\i somefile` execute commands from a file
- `select * from foobale where barcolumn is not null;` - find non-null rows
### ARRAYS
```sql
-- assume we have text[] type column
select * from footable where arrcol[1] = 'dude';  -- find all where first element of array is 'dude'

-- find all where arrcol contains 'dude' 
--NOTE: ANY must be right hand side
select * from footable where 'dude' = ANY (arrcol);  

select col1,unnest(arrcol) from footable;  -- unnest will flatten, each item in array becomes a new row in results
```

## CONCEPTS
- postgres schema - really a namespace in a database, not to be confused with general software concept of structure of data and relations
- table inheritence - child tables can inhert properties from parent table
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
    - horizontal method 1: create table partitions on other servers and use FDWs to represent the logical table
    - horizontal method 2: each db shard is totally seperate, a seperate service/layer uses key to route to correct shard
    - vertical method: create a partition on different tablespaces (on different disks)
### SINGLE VS MULTI
- single master - replicas just for backup, replica can be hot(do read queries)
- multi-master (active-active) setup
    - has eventual data consistency
    - bi-direction replication, changes made to one master are replicated to other masters

## REPLICATION
- good doc: https://en.wikibooks.org/wiki/PostgreSQL/Replication
- two major types: logical and physical
- synchronicity
    - synchronous replication - master waits till atleast one replica wrote a transaction to it's log
        - fine-grain tunable, can specify per-db, per-user, per-session
    - async - data send without waiting for confirmation replicas got each message
- trigger replication, SUPER old, table triggers used to send data to replicas, this predates WAL
### WAL
- WAL = Write-ahead logs, a type of journaling, describing low level binary data changes
    - when transaction is commited, WAL log is written first, then eventually the real data storage(tables, index)
- if server fails, WAL logs always exist to retreive lost data, it provides the durability in ACID for postgres
    - in system crashes, logs for uncommited transactions are discarded, and commited logs not in main file is written
- WAL file fast to write (sequential data), and b/c we dont have to write the data (data pages are slow to write)
- shipping
    - log shipping - old school way to send WALs to replicas
        - log shipping is most often done with physical replication, but can be logical too
        - when a WAL log file is full (~16MB), master not writing to it, then whole file is sent to replica
    - streaming is sending each WAL log on a TCP connection
- continuous archiving - means old WAL files can be archived when not needed
### PHYSICAL REPLICATION
- aka binary replication
- low level storage data (exact block address, byte-by-byte) is sync'd to replicas
- offers HA
    - warm standby - replica available for hot swapping when master dies, can't do read queries
    - hot standby - warm + can do read queries
    - cold standy - not official term, often refers to replica that uses log shipping, WALs not processed until standby starts up
- disadvantage: must replicate all data in the db
- basic process
    - SQL statements are run on a master node
    - transaction is commited
    - this generates WAL
        - the [WAL](https://www.postgresql.org/docs/current/wal-intro.html) is written first before the data it describes is written
    - WALs sent to replicas
    - read replicas read the WAL records and replay them, so they have a copy of master
### LOGICAL REPLICATION
- introduced in version 10
- essentially high level SQL statements are sync'd to replicas
- advantage: can control which tables and data get replicated
- uses a pub/sub model to replicate
    - WAL transactions are decoded to high level sql statements and then published
    - advantage: flexibility and changing where the data goes, can add subscriberes in various location dynamically and fast
- disadvantage: cant copy sequences, large objects, materialized views, partition root tables, and foreign tables
- can only do DMLs, not DDLs (subscribers need to manually do DDLs)

## QUERY TIPS
```sql
-- date range
SELECT * FROM events WHERE event_date >= '2023-02-01' AND event_date <= '2023-04-30'

-- counting num records in db table
SELECT count(1) from footable;  -- slow but accurate

-- for big table 
-- from https://stackoverflow.com/questions/7943233/fast-way-to-discover-the-row-count-of-a-table-in-postgresql
-- fast but somewhat innaccurate
SELECT reltuples AS estimate FROM pg_class where relname = 'mytable';
-- even better
SELECT reltuples::bigint AS estimate FROM pg_class WHERE  oid = 'myschema.mytable'::regclass;
```
- terminate db connections
    `psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${1}' AND pid <> pg_backend_pid()" -d postgres`


## SPECIAL TABLES
- https://www.postgresql.org/docs/current/monitoring-stats.html
- `pg_stat_activity` a view that shows queries running per process
- `pg_locks` a view that shows locks owned by various processes and transactions
- `pg_stat_progress_create_index` - show status of index creation
