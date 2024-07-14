# DATASTORES

## CONCEPTS
- normalization - reducing the duplication of data to different levels
- NoSQL: term can refer to many different paradigms bug are generally: column, document, key-value, and graph
- impedance mismatch - concept of friction/incompatibility of ORMs, OO <-> relational data mapping issues
- N+1 query problem - app code that translates to 1 query from a table and N extra seperate queries from a related table
- sequential access is faster than random access on underlying storage mediums
    - particularly true for HDD, lot of physical movement, needle movement, platter movement


## RELATIONAL
- 2024 - oracle generally still considered more scalable/performant vs postgres, particularly with write-heavy complex queries
- cardinality - the amount of unique values in a column relative to the table size
    - boolean column only has 2 unique values, super low cardinality
- tablespace vs schema - https://stackoverflow.com/questions/35120219/a-database-schema-vs-a-database-tablespace
- transactional DDL - can rollback DDLs like transactional DMLs
    - rolloback whole table creations even
### DOCS
- https://use-the-index-luke.com/
### POSTGRESQL
- see [postgresql](postgresql_cheatsheet.md)
### SQLLITE
- an embedded database written in C, it's not a standalone process/server
- `.quit` - exit the sql client
- `.tables` - list tables
- `.schema footable` - get a table's description
- `.mode line` - display each records column in seperate line
### SQL LANGUAGE
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
- index types
    - composite - index on a tuple of two or more columns
    - conditional/partial - only index some rows
### PARTITIONING
- sharding - typically means partitioning and each partition is on an different db instance
    - allows more scalability and peformance vs partitioning
    - more fault tolerance in that if a db shard instance goes down, other shards are still live
        - though even in single db instance, most setups will have HA with master/slave
- horizontal vs vertical
    - horizontal - splitting table based on rows
        - can infinitely scale
    - vertial - splitting a table based on columns
        - limited scalability, max number of partitions is number of columns


## COLUMN DB
### BIGTABLE
- invented by google in 2004
- it inspired HBASE and Cassandra
### HBASE 
- unlike cassandra has leader/master based replication
- also wide-column like cassandra
### CASSANDRA
- first version created by facebook in 2008, released as open source, falls under NoSQL db
- doesnt have a formal master/leader, uses masterless async replication peer-to-peer communication
- uses consistent hashing for sharding
- data is replicated between the peers
    - replication factor of 3 means 2 peers have copies
    - reads are load balanced between replicas
- uses gossip protocol to send new state data to neighbors
- uses quorum writes - send requests to replicate data in many other nodes, dont have to wait for all nodes to respond
- uses a distributed consensus protocol in case of a failure
    - reqd quorum - if a minimum number of nodes agree on a response it is used
    - cases for inconsistency are rare, an example where it could happen, quorum=2:
        - node A get a write, replicates to B and C (replication factor 2)
        - A dies, network is slow, B and C didnt get update yet
        - user does a read
            - cant consult A, B and C still didnt get update, quorum=2, both agree with old value and this is returned
            - say A and B did get update before read, quorum=2, both agree with new correct value and this is returned
            - say B gets update, C doesnt, then we dont have quorum=2 so query fails
    - in above if quorum=3, then query always fails, b/c only B and C can possibly agree getting to 2 only
- storage model - based on google's bigtable concept
    - each node has an in-memory log of key/value pairs, that's stored sequentially
    - periodically the in-memory log is flushed to a SST(sorted string table) persistent store, where it's sorted by key
        - SST is immutable, each write/updates to same key results in a new record
    - can use timestamps to get the latest value for a key
    - problem is lots of extra space used from redundancy
    - cassandra and elasticsearch offer compaction to reduce this, which uses mergesort on SSTs


## DOCUMENT DB
- single "document" or blob, no normalization like relational, much more repeated data
- a collection can specify schemas and they are generally more easily changable vs relational schemas
- typically document dbs are designed for easier horizontal scale
    - they typpically come ready/plug-and-play supporting easy horizontal sharding
- disadvantage: generally to update a field you update the entire document
- disadvantage: generally dont have the ACID gaurantees of relational
- disadvantage: not as read optimized vs relational, usually u have to read whole document
    - you can create indexes on fields
### DYNAMODB 
- created by AWS
### MONGO
- [main cheatsheet](mongo_cheatsheet.md)
- supports schemas for collections - https://www.mongodb.com/docs/manual/core/schema-validation/
    - for JSON uses json-schema (jul2024 - draft 4)
- uses leader-based replication


## KEY-VALUE
- memcached
### REDIS
- redis does have a native compare-and-swap operation but you could write a lua script easily
- redis has a lua JIT inside it for scripting
    - a lua script runs atomically
- modes
    - single - one instance
    - cluster - horizontal scaling with sharding
        - key divided into hash slots(16384 total), calculated by CRC16 of the key modulo 16384
        - every node responsible for subset of hash slot space (e.g. 3 nodes: A=(0-5500), B=(5501-11000), C=(11001-16383))
            - this does NOT use consistent hashing
        - supports master/replica, so each shard has replica, A,B,C has A1,B1,C1, if A goes down A1 takes over
        - no strong consistency gaurantee, b/c of async replication, some writes can be lost
            - 1. client writes to master, 2. master replies OK, 3. master sends to replicas.
            - if master dies b4 replication, replica promoted, and write lost but client thinks it happened
        - clients hits a master shard, and it will redirect client to correct shard, client remembers, shards do not proxying
    - sentinel - high availibility (not clustering)
- apr'24 - redis went partially closed source, cant host on cloud for free
- apr'24 - FOSS fork of redis: https://github.com/valkey-io/valkey
- COMMANDS
    - FLUSHALL
    - KEYS *
    - MONITOR
    - HGETALL <key name>
### AWS ELASTICACHE
- has a redis-compatible imitator mode, and also memcached mode
- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.corecomponents.html
    - uses proxy layer (load balancers and proxy nodes) to manage connect to cluster and getting to right shard

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
    - a transaction, which means all operations in transaction happen or none of them do
- Consistency
    - atomicity, isolation, and durability are properties of db itself, consistency is specified by programmer
    - consistency in data, features that facilitate data validatity
        - e.g. can create a FK relationship, a row that has a FK to it can't be deleted
        - e.g uniqueness index, data in column cannot be duplicated
- Isolation
    - transactions run in ioslation of other transactions
- Durability
    - committed transactions cannot be lost, i.e. persisted on durable non-volatile storage

## GRAPH
- Neo4j - most established and well known

## CDN
- content delivery network
- pull vs push 
    - push: engineers need to manually push content to CDN for clients to find
    - pull: when the client requests content from CDN, the CDN retreives it from the origin server

## SPREADSHEETS
- yea... ridiculous but many companies will use em in prod for data
- famously level.fyi used google sheets for prod for long time

## TECH
- vitess - a db clustering system using mysql, created by google
    - each mysql server is a horizontal shard abstracted as a single entity by vitess
    - used by youtube sincd 2011, composed of tens of thousands of mysql instances
    - also used by slack
