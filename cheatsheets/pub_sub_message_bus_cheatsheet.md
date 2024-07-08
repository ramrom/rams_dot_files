# PUB SUB MESSAGE BUS CHEATSHEET

## KAFKA
- apache kafka 2 is like 20% scala (0.7 was like 50%)
    - 3.1.0 - `core` (most important module) written in scala
- each partition is replicated on many brokers
- apache zookeeper often used to maintain kafka cluster
    - tracks which broker is responsible for which partitions and topics
- kafka has _logs_ not _messages_
    - logs are persistent, they stick around until the TTL expires
    - in message queues, messages are deleted immediately after consumers get them
    - b/c it's persistent, consumer requests an offset # of the log, and can rerequest or get older messages
- logs/messages
    - has a key, and hash of key decides target partition
    - if key is empty, partion field is used
    - if key and partition empty, then message is round robin sent to all partitions
- each broker is a seperate server
    - replicas of partitions are on different brokers
- brokers support acknowledgement of the delivery of messages from producers, there are 3 acknowledgement modes
    - ack=0 -> no acks, producer doesnt wait for acks
    - ack=1 -> waits for leader broker ack
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
    - messages have a global sequence number
    - messages on a partition are guarunteed to be delivered to subscribers in order they were publishes
    - if a topic lives on one partition, message order is guaranteed at topic level
        - disadvantage here is that this caps the throughput/scalability
    - if on many partitions, messages are distibuted and topic-level order not guaranteed obviously, but partition level is

## APACHE FLUME
- messsages are pushed to consumer

## AMAZON SNS/SQS
### SQS
- standard queue: messages can out of order, at-least one delivery, but have higher throughput
- FIFO queue: guaruntees order of messages, has unique message IDs to handle duplication
- latency in milliseconds, max msg size 256kB
- consumers pull from queue
### SNS
- messages pushed to conusmer, can configure to push a SQS that consumer owns/pulls from

## RABBITMQ
- pushes messages to consumer
