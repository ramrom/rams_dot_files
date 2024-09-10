# PUB SUB MESSAGE BUS CHEATSHEET
- message delivery semantics
    - at-most once - messages can be lost but are never redelivered
    - at-least once - never lost but could be redelivered
    - once only - delivered once and only once
- push vs pull
    - push - messages are pushed to consumer
        - pro: lowest latency, con: no flow control and can overwhelm client
    - pull - conumser must request for messages
        - pro: generally an easier system to impelment, con: consumer has to do more work
        - pro: client can bulk retrieve many messages, pro: wont get overwhelmed
- order
    - FIFO - message order gauranteed, consumer gets messages in order they were added to queue

## KAFKA
- apache kafka 2 is like 20% scala (0.7 was like 50%)
    - 3.1.0 - `core` (most important module) written in scala
- uses apache zookeeper to manage it
    - 2024 - zookeeper has limitations and work ongoing to remove it
- apache zookeeper often used to maintain kafka cluster
    - tracks which broker is responsible for which partitions and topics
- each topic partition is an ordered, immutable sequence of logs, append only
- kafka has _logs_ not _messages_
    - logs are persistent, they stick around until the TTL expires
    - generally in _message_ queues, messages are deleted immediately after consumers get them
    - b/c it's persistent, consumer requests an offset # of the log, and can rerequest or get older messages
    - reads start from an offset and are sequential, with all data zero-copied from the disk buffer to the network buffer
        - data is copied from disk to page cache(kernel buffer)
        - page cache copied directly to NIC buffer (on linux `sendfile` syscall does this)
            - so `read` and `write` sys calls in userland program and some kernel context switches are avoided
- logs/messages
    - has a key, and hash of key decides target partition
    - if key is empty, partion field is used
    - if key and partition empty, then message is round robin sent to all partitions
- each broker is a seperate server
    - replicas of partitions are on different brokers
- brokers support acknowledgement of the delivery of messages from producers, there are 3 acknowledgement modes
    - ack=0 -> no acks, producer doesnt wait for acks
    - ack=1 -> waits for leader broker ack
        - this mode gives at-least-once gaurantee, but not consistency if master dies after ack and replicas didnt get msg and promote
        - doesn't prevent more-than-one b/c maybe producer sends duplicate msg b/c the ack takes to long to arrive (use idempotency)
    - ack=2 -> wait for acks from all in-sync replicas of a partition
        - leader broker waits for all in-sync replicas to receive b4 sending ack
- consuming is pull based, so consumer can choose what pace they consume
    - advantage: is backpressure management, as consumer wont get overwhelmed as it consumes at a rate it can handle
    - advantage: efficient batching(mult msgs in one pull), consumer knows better the batch size and timing
    - polling is has it's issues: higher latency as u dont get msg until u ask, consumer has to implement a polling loop
        - kafka supports "long poll", consumer can specify this in request with timer, poll wont return till msg return or timer expires
- consumer groups
    - each consumer group is a seperate subscriber, consumers are identified by group ID
    - message are uniquely read by one consumer in a consumer group
    - messages are evenly distrubuted between consumers in a consumer group
        - for a topic on 6 partitions read by 2 consumers with same group ID, each consumer will read messages from 3 partions
        - kafka guarantees each consumer will read from unique subset of partitions
    - 2 consumers with different group IDs will each read the messages from the same topic
- message ordering
    - messages on a partition are guarunteed to be delivered to subscribers in order they were publishes
    - if a topic lives on one partition, message order is guaranteed at topic level
        - disadvantage here is that this caps the throughput/scalability
    - if on many partitions, messages are distibuted and topic-level order not guaranteed obviously, but partition level is
    - for many producers, a db sequence or distributed counter could be leveraged to ensure unique seq # b/w all producers
- duplication
    - kafka 0.11 - idempotent producer (exactly once delivery gaurantee), uses a Producer ID (PID) and a sequence number as idempotency key
        - idempotency key must be unique for a given partition, a msg with same idempotency key is a dup and discarded
        - e.g. could happen if producer retries b/c of network fault(didnt reach kafka) or not getting an ack from kafka
        - caveat: if producer dies and restarts, it gets assigned a new PID, no idempotency gaurantee then

## APACHE PULSAR
- similar to kafka, written entirely in java
- more complex, has 4 main components: pulsar servers, apache zookeeper, apache bookeeper, rocksDB 
- write to a index-based storage system, fast for random access, but slow for overall througput compared to kafka sequential logs

## APACHE FLINK
- real-time large data stream/batch processing framework, simlar to kafka streams or apache spark
    - has a JobManager and TaskManager(aka workers), jobmanager schedules jobs to taskmanagers
    - flink apps can be written in java/scala/python or sql
- versus spark, it's considered more lower latency and real-time
- historically started as a stream framework, then batch

## APACHE SPARK
- analytics engine that can stream/batch process, can also do ML and graph processing
    - used for data warehousing, ETL, ML, and more
- historically started as a batch framework, then stream
- apache spark is like 70% scala

## APACHE FLUME
- messsages are pushed to consumer

## AWS SNS/SQS
### SQS
- standard queue: messages can out of order, at-least one delivery, but have higher throughput
- FIFO queue: guaruntees order of messages, has unique message IDs to handle duplication
- latency in milliseconds, max msg size 256kB
- consumers pull from queue
- reading from queue
    - messages not deleted, marked invisible once consumed, other consumers wont get invisible messages
    - deletion API should be used (generally by same consumer) to remove them, otherwise message will become visible later
### SNS
- messages pushed to conusmer, can configure to push a SQS that consumer owns/pulls from
- e.g. consumers can be SQS, kinesis, lambda
- SMS support: supports SMS delivery direct cell phones or to a topic(which then can delivery to cells)

## RABBITMQ
- pushes messages to consumer
