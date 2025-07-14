# DATASTORES

## DOCS
- w3 school sql for dummies - https://www.w3schools.com/sql/sql_syntax.asp

## CONCEPTS
- normalization - reducing the duplication of data to different levels
- NoSQL: term can refer to many different paradigms bug are generally: column, document, key-value, and graph
- impedance mismatch - concept of friction/incompatibility of ORMs, OO <-> relational data mapping issues
- N+1 query problem - app code that translates to 1 query from a table and N extra seperate queries from a related table
- sequential access is faster than random access on underlying storage mediums
    - particularly true for HDD, lot of physical movement, needle movement, platter movement
- NoSql vs relational
    - use relational when you know your schema is well defined and narrow (know exactly what fields and types)
    - if you have a blob of data but dont know which parts you might need later, use a blob/nosql store
- EAV(entity-attribute-value) pattern
    - a method to store sparse data, large number of "fields"/"attributes" and each entity fills a different set of them and usually a few
    - common implementation: table with `entity` column, `attribute` column, and `value` column
        - oftentimes `attribute` column is a FK to a lookup table
        - `attribute` table might have `attribute_id`, name, desc, a data type, set of valid values, and more
    - an modern alternative to EAV is to use a document store like JSON blob
- OLTP vs OLAP
    - OLTP = online transaction processing - realtime, large volume, usually use a relation DB
    - OLAP = online analytic processing - slow complex queries, used by analysts for BI
    - https://www.datawarehouse4u.info/OLTP-vs-OLAP.html
- data warehouse
    - historically batch process would ETL data from OLTP DBs overnight
- data lake
    - genreally an evolution from data warehouse, really kind of a distributed file system 
    - general idea is to get away from schemas and complications of ETLing for different schemas
    - initally done by hadoop
    - diff b/w datawarehouse is you dont transform before entering data lake, it's transformed later
    - oftentimes just S3 buckets


## RELATIONAL
- 2024 - oracle generally still considered more scalable/performant vs postgres, particularly with write-heavy complex queries
- cardinality - the amount of unique values in a column relative to the table size
    - boolean column only has 2 unique values, super low cardinality
- tablespace vs schema - https://stackoverflow.com/questions/35120219/a-database-schema-vs-a-database-tablespace
- transactional DDL - can rollback DDLs like transactional DMLs
    - rolloback whole table creations even
- primary key
    - blog on UUID as primary key: https://tomharrisonjr.com/uuid-or-guid-as-primary-keys-be-careful-7b2aa3dcb439
### TYPES
- blobs - binary large objects - a type to use if storing large files like binaries or multimedia(images, video)
### DOCS
- https://thoughtbot.com/blog/reading-an-explain-analyze-query-plan - lesson on how `EXPLAIN ANALYZE` works
- https://use-the-index-luke.com/ - good tutorial on how indexes work
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
- horizontal vs vertical
- horizontal - splitting table based on rows
    - can infinitely scale
- vertial - splitting a table based on columns
    - normalization is also a type of vertical partitioning
    - limited scalability, max number of partitions is number of columns
### SHARDING 
- typically means partitioning horizontally and each partition is on an different db instance
- allows more scalability and peformance vs partitioning
- more fault tolerance in that if a db shard instance goes down, other shards are still live
    - though even in single db instance, most setups will have HA with master/slave
- routing logic 
    - clients can implement the routing logic to get to proper shard internally (like a library)
    - or shard cluster can have a router/gateway that handles it, client just sees one logical instance
- sharding strategy - what data do you use to create a shardkey(which determines which shard it belongs to)?
    - business rule strategy - some business logic/domain data makes sense for the use case to shard on
        - e.g. geolocated data, like city data, each shard should store data for cities in the same region
    - hashing shard strategy - good when u dont have a clear key to use based on business
        - take a hash of the shard key (maybe id) and then mod it by number of shards
- difficulty is when you add and remove shards - you have to remap key space and means migrating data


## COLUMN DB
- each value for a key can represent a different set of "columns" or fields, so diff version of keys could have diff sets of fields
    - this is why peeps call it a column DB
### BIGTABLE
- invented by google in 2004
- it inspired HBASE and Cassandra
### HBASE 
- unlike cassandra has leader/master based replication
- also wide-column like cassandra
### CASSANDRA
- first version created by facebook in 2008, released as open source, falls under NoSQL db
    - facebook created it handle large volumes of data, particularly for searching their facebook inbox
    - addresses scale for growing writes, can add nodes easy for scale, and can replicate to diff data centers for lower latencies
- doesnt have a formal master/leader, uses masterless async replication with peer-to-peer communication
- uses consistent hashing for sharding, each peer is a main owner of a shard of the data
- data is replicated between the peers
    - replication factor of 3 means 2 peers have copies
    - reads are load balanced between replicas
- uses gossip protocol to send new state data to neighbors
- uses async quorum writes - send requests to replicate data in many other nodes, dont have to wait for all nodes to respond
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
- storage model
    - each node uses a LSMT
    - writes to the in-memory cache are written to a WAL for durability, log only read for crash recovery scenarios

## LSMT
- LSMT = Log Structured Merge Tree
    - 2 components: 1. in-memory cache(memtable), 2. on-disk/persistent component - SST(sorted string table)
- great for high-write use cases, while still having good read performance
    - there are no relations so cant do SQL queries really
- used by RocksDB and Cassandra
- read path -> search memtable first, then search SST
### MEMTABLE
- in-memory log of key/value pairs
    - often a linked-list, this enables fast writes as insertions are O(1)
    - but other structs like red-black trees, O(logN) insertion time, are good too
    - writes to an existing key updates it's value (i'm pretty sure about this)
- when in-memory log is full it's made immutable and new writes are made to a new in-memory log
    - then the full log is flushed to on-disk component, a SST
    - batching improves performance by reducing many IO calls to one
- one disadvantage here is that lots of extra space used from redundancy
### SST
- SST = sorted string table, on-disk persistent store, composed of many segments
    - SST inspired by a data struct in google BigTable
    - each flush from a memtable comprises a segment of data, key/values are sorted in each segment by key
- SST is immutable, each write/updates to same key results in a new record
- reading on a key
    - means starting with latest segment and binary search, if not there goto next latest segment
    - in worst case key is in the earliest segment, so O(NlogK) time (N segments, K keys/segment)
- sparse index (cassandra uses this)
    - used to speed up reads on disk - limits the number of segments to access for a read
    - is a BTREE stored in-memory, each item in index stores first key in each segment and where segment is located on disk
    - only need to search segments where first segment key is before desired key
        - e.g. we want key "foo", say 10 segments in index, 3rd seg is "bar", 4th seg is "gig"
        - segment "gig" wont have "foo", but segment "bar" might, and also 1st and 2nd segment, so just search 1st,2nd,3rd segment
- bloom filter optimization (cassandra and rocksDB does this)
    - can use a bloom filter to keep track of what keys are in the SST segment
    - no false negatives, so can definitely ignore searching SST then, saving time for a read
    - can increase filter size (esp during compaction) to redude false positive rate
- deletion of key - uses tombstones; a marker that indicates key is deleted when read
    - key can be hard deleted during compaction
- compaction - merging two segments of SST into one in the background
    - this greatly increases read performance
    - only recent values of a key are kept, also reducing total storage
    - two major types: sized tiered compaction and leveled compation
        - sized-tiered is write optimized, leveled is read optimized
        - cassandara uses sized-tiered and rocksDB uses leveled


## DOCUMENT DB
- single "document" or blob, no normalization like relational, much more repeated data
- good also if document is a large size, like 1MB
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
- [mongo hacker](https://github.com/TylerBrock/mongo-hacker) - good lib for mongo scripting
    - *UNMAINTAINED* - use https://github.com/mongodb-js/mongosh instead maybe


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
- persistence
    - RDB(Redis Database) - backups, minimum latency/perf hit, forked process does all the backup work
    - AOF(Append Only File) - like WAL, can fsync every second, every write, no fsync
    - can also do no-persistence or AOF+RDB
- supports transactions - https://redis.io/docs/latest/develop/interact/transactions/
- HISTORY
    - apr'24 - redis went partially closed source, cant host on cloud for free
    - apr'24 - FOSS fork of redis: https://github.com/valkey-io/valkey
- COMMANDS
    - full list - https://redis.io/docs/latest/commands/
    - `FLUSHALL` - remove all keys in all databases
    - `KEYS *` - list all keys
    - `MONITOR`
    - `HGETALL <key name>` - get all data in key
    - `INFO` - get server info, e.g. cpu, replication, modules, cluster, stats, clients, etc
    - `SET A B` - set key `A` to value `B`
    - `GET A` - get value of key `A`
    - `HSET H A B` - set key `A` to value `B` in hash `H`
    - `HGET H A` - get key `A` of hash `H`
    - `HGETALL H` - get all key/values in hash `H`
- CLI
    - default host = `localhost`, default port = `6379`
    - `redis-cli -a foopass` - connect with password `foopass`
    - `redis-cli PING` - connect to redis (default host/port here), and run `PING` command
### AWS ELASTICACHE
- has a redis-compatible imitator mode, and also memcached mode
- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.corecomponents.html
    - uses proxy layer (load balancers and proxy nodes) to manage connect to cluster and getting to right shard

## TIME SERIES
- graphite
- influxDB

## DISTRIBUTED FILE SYSTEMS
- examples: GoogleFS, GlusterFS, HDFS(hadoop distributed file system), NFS
### GOOGLEFS
- designed early by larry page an sergei brin
- optimized for cheap commodity hardware, files split into 64MB chunks, optimized for read and append

## GRAPH
- Neo4j - most established and well known
- facebook uses a graph db to store friends and their relationships to other friends
    - facebook graph search engine uses a graph db

## LOCKS
- pessimistic vs optimistic
    - pessimistic -> aquire expclit locks, good for if conflicts can occur often
        - strict two-phase locking (2PL) is a common type of this
    - optimistic -> good when conflicts are rare, check if so at end and then cancel/rollback if conflict did occur
        - also called OCC (optimistic concurrency control)
        - MVCC (postgres uses this) is optimistic
        - timestamp-based control is the other major type
- https://vladmihalcea.com/how-does-mvcc-multi-version-concurrency-control-work/ - nice examples on MVCC
    - has an insert, delete, update example

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
    - serializable is a property meaning concurrent transactions are applied as if the server was single threaded
- Durability
    - committed transactions cannot be lost, i.e. persisted on durable non-volatile storage
    - for POSIX systems `sync`, `fsync`(`sync` for one file) and `fdatasync`(no metadata update) flush the buffer cache to storage drive
        - note these calls flush kernel caches only, storage drives often have internal caches

## CDN
- content delivery network
- famous examples: akamai, cloudfront, cloudflare, netflix open connect
- pull vs push 
    - push: engineers need to manually push content to CDN for clients to find
        - pro: lower latency as content always there, con: wastes space if clients dont request it
    - pull: when the client requests content from CDN, the CDN retreives it from the origin server
        - pro: only data that is needed is stored on CDN, con: higher latency than push

## SPREADSHEETS
- yea... ridiculous but many companies will use em in prod for data
- famously level.fyi used google sheets for prod for long time

## TECH
- [tigerbeetle](https://github.com/tigerbeetle/tigerbeetle) - 2023ish newish financial transaction db
    - built in zig, super high volume, high performance, high fault tolerance
- vitess - a db clustering system using mysql, created by google engineers, those engineers later created planetscale and use vitess
    - each mysql server is a horizontal shard abstracted as a single entity by vitess
        - prolly used mysql b/c in 2005 document store like mongoDB didnt exist
    - used by youtube sincd 2011, composed of tens of thousands of mysql instances
    - also used by slack
