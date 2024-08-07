# CLOUD CHEATSHEET

## AWS
- VPC - virtual private cloud
    - VPC cannot span many regions, can peer two VPCs from two regions together, but address range of each cannot overlap
- a aws account comes with a default VPC
- can share VPCs between multiple accounts
- SSM - systems mananger agents - https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html
- cloudfront - CDN
- AWS WAF - web access firewall (firewall, bot detection, other rules)
### CONCEPTS
- organization - contains many accounts
- IAM(identity and access management) - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
    - policy - set of generic rules
    - 3 types of policies: session, identity, resource
    - when applied in context of an identity, session, and resources, define the permissions

## LOAD BALANCERS
- ELB - elastic load balancer - https://aws.amazon.com/elasticloadbalancing/features/
- ALB - application load balancer
    - layer 7: HTTP, HTTPS, gRPC
    - very flexible
- NLB - network load balancer
    - layer 4: TCP, UDP, TLS
    - for high performance, using static IPs
- Classic load blaancer
    - if system built with EC-2 classic network
