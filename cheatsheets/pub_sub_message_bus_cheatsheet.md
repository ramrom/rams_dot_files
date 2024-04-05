# PUB SUB MESSAGE BUS CHEATSHEET

## KAFKA
- consumer groups
    - each consumer group is a seperate subscriber, consumers are identified by group ID
    - message are uniquely read by one consumer in a consumer group
    - messages are evenly distrubuted between consumers in a consumer group
        - for a topic on 6 partitions read by 2 consumers with same group ID, each consumer will read messages from 3 partions
        - kafka guarantees each consumer will read from unique subset of partitions
    - 2 consumers with different group IDs will each read the messages from the same topic
- message ordering
    - messages have a global sequence number
    - if a topic lives on one partition, message order is guaranteed, but this caps the throughput/scalability
    - if on many partitions
