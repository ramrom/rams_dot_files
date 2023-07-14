# CLOUD CHEATSHEET

## AWS
- VPC - virtual private cloud
    - VPC cannot span many regions, can peer two VPCs from two regions together, but address range of each cannot overlap
- a aws account comes with a default VPC
- can share VPCs between multiple accounts

## LOAD BALANCERS
- ALB - application load balancer
    - layer 7: HTTP, HTTPS, gRPC
- NLB - network load balancer
    - layer 4: TCP, UDP, TLS
- ELB - elastic load balancer
    - https://aws.amazon.com/elasticloadbalancing/features/
