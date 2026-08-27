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

## IAM
- IAM(identity and access management) - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
    - IAM vs STS(security token service) - STS issues the creds
    - ARN(amazon resource name) structure looks like: `arn:partition:service:region:account:resource`
        - docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-arns
    - policy - set of generic rules
        - e.g. allow/deny for some action
    - 3 types of policies: session, identity, resource
    - when applied in context of an identity, session, and resources, define the permissions
    - role vs user
        - role is temporary, assuamble identity with short lived creds
        - user is permanent identity with long-term creds

## NETWORK
- VPC = virtual private cloud
    - must belong to one AWS account
- an aws account can contain main VPCs, limit is around 100 VPCs per account per region
### SUBNET
- a VPC has many subnets
- each subnet is a portion of the VPC's total address range
- a subnet must reside within an AZ

## MANAGED SERVICES
- Aurora - their own complex relation database system
- firecracker - very lightweight VM, low latency, written in rust, that is used by their lamdba serverless and fargate
    - one way it's lightweight is very minimal device support, e.g. no USB support
- lambda - serverless functions
- fargate - serverless worker(compute engine) to run a task, abstracts aways VM/server
    - a fargate task is defines the container image, resources, network settings, etc
    - can run on ECS or EKS
- ECS - elastic container service
    - manages and decides how to run containers, the orchestrator, competes with kubernetes
    - a cluster has many services
    - a service manages lifecycle of idential tasks, links to one or more target groups
        - a task could be fargate task for EC2 task
        - handles registration and removal of tasks from target groups
    - a target group is a collection of healthy endpoints or IPs, it connects to listeners on an ALB
    - can have one ALB route to many target groups, e.g. host-based or path-based rules
- EKS - Elastic Kubernetes Service, AWS hosted k8 system

## AWS CLI
- `aws configure --profile someprofile list`  - list sessions under that profile
- `aws configure export-credentials --profile someprofile`  - display creds in diff format (JSON default)
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
