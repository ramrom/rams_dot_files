# PUB SUB MESSAGE BUS CHEATSHEET

## KAFKA
- each partition is replicated on many brokers
- brokers support acknowledgement of the delivery of messages from producers, there are 3 acknowledgement modes:
    - acks=0 -> no acks, producer doesnt wait for acks
    - ack=1 -> waits for leader broker ack
    - ack=2 -> wait for acks from all in-sync replicas of a partition
        - leader broker waits for all in-sync replicas to receive b4 sending ack
- consuming is pull based, so consumer can choose what pace they consume
    - being pull based, there is some inefficienty in that it polls
- consumer groups
    - each consumer group is a seperate subscriber, consumers are identified by group ID
    - message are uniquely read by one consumer in a consumer group
    - messages are evenly distrubuted between consumers in a consumer group
        - for a topic on 6 partitions read by 2 consumers with same group ID, each consumer will read messages from 3 partions
        - kafka guarantees each consumer will read from unique subset of partitions
    - 2 consumers with different group IDs will each read the messages from the same topic
- message ordering
    - messages have a global sequence number
    - messages on a partition are guaruntees to be delivered to subscribers in order they were publishes
    - if a topic lives on one partition, message order is guaranteed at topic level
        - disadvantage here is that this caps the throughput/scalability
    - if on many partitions, messages are distibuted and topic-level order not guaranteed obviously, but partition level is
