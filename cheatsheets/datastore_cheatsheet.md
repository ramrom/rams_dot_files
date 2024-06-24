# DATASTORES

## CONCEPTS
- normalization - reducing the duplication of data to different levels
- NoSQL: term can refer to many different paradigms bug are generally: column, document, key-value, and graph


## RELATIONAL
- 2024 - oracle generally still considered more scalable/performant vs postgres, particularly with write-heavy complex queries
- postgres: see [postgres](postgres_cheatsheet.md)
- cardinality - the amount of unique values in a column relative to the table size
    - boolean column only has 2 unique values, super low cardinality
- tablespace vs schema - https://stackoverflow.com/questions/35120219/a-database-schema-vs-a-database-tablespace
- transactional DDL - can rollback DDLs like transactional DMLs
    - rolloback whole table creations even
### SQLLITE
- an embedded database written in C, it's not a standalone process/server
- `.quit` - exit the sql client
- `.tables` - list tables
- `.schema footable` - get a table's description
- `.mode line` - display each records column in seperate line

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
- GIST/GIN - postgres indexes for string search
- Geospatial
    - redis GEOHASH
    - postgres PostGIS extension
### DOCS
- https://use-the-index-luke.com/

## COLUMN DB
### BIGTABLE
- invented by google in 2004
- it inspired HBASE and Cassandra
### HBASE 
- unlike cassandra has leader/master based replication
- also wide-column like cassandra
### CASSANDRA
- first version created by facebook in 2008, released as open source
- doesnt have a master/leader, uses masterless async replication peer-to-peer communication
- data is replicated between the peers
- uses gossip protocol to send new state data to neighbors
- uses quorum writes - send requests to replicate data in many other nodes, dont have to wait for all nodes to respond
- reqd quorum - if a minimum number of nodes agree on a response it is used
- uses consistent hashing for sharding

## DOCUMENT DB
- dynamodb - created by AWS
### MONGO
- uses leader-based replication
- also see [mongo](mongo_cheatsheet.md)

## KEY-VALUE
- memcached
### REDIS
- apr'24 - redis went partially closed source, cant host on cloud for free
- apr'24 - FOSS fork of redis: https://github.com/valkey-io/valkey
- COMMANDS
    - FLUSHALL
    - KEYS *
    - MONITOR
    - HGETALL <key name>

## TIME SERIES
- graphite
- influxDB

## GRAPH
- Neo4j

## LOCKS
- pessimistic vs optimistic
    - pessimistic -> aquire expclit locks, good for if conflicts can occur often
        - strict two-phase locking (2PL) is a common type of this
    - optimistic -> good when conflicts are rare, check if so at end and then cancel/rollback if conflict did occur
        - also called OCC (optimistic concurrency control)
        - MVCC (postgres uses this) is optimistic
        - timestamp-based control is the other major type

## ACID
- Atomicity
- Consistency
- Isolation
- Durability

## GRAPH
- Neo4j - most established and well known

## CDN
- content delivery network
- pull vs push 
    - push: engineers need to manually push content to CDN for clients to find
    - pull: when the client requests content from CDN, the CDN retreives it from the origin server

## TECH
- vitess - a db clustering system using mysql, created by google
    - each mysql server is a horizontal shard abstracted as a single entity by vitess
    - used by youtube sincd 2011, composed of tens of thousands of mysql instances
    - also used by slack
