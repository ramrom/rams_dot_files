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
    - IAM vs STS(security token service) - STS issues the creds
    - ARN(amazon resource name) structure looks like: `arn:partition:service:region:account:resource`
        - docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-arns
    - policy - set of generic rules
    - 3 types of policies: session, identity, resource
    - when applied in context of an identity, session, and resources, define the permissions
    - role simply is "what can I do?", so permissions

## TECH
- Aurora - their own complex relation database system
- firecracker - very lightweight VM, low latency, written in rust, that is used by their lamdba serverless and fargate
    - one way it's lightweight is very minimal device support, e.g. no USB support

## AWS CLI
- `aws configure --profile someprofile list`  - list sessions under that profile
- `aws configure list-profiles`  - list profiles with sessions
- `aws eks --profile foo --region us-east-1 list-clusters` - list eks clusters in a region

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
