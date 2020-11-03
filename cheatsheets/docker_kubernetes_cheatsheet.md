# DOCKER/KUBERNETES

## DOCKER
- https://docs.docker.com/
- Dockerfile is code that defines how to build a docker image
- an image is instantiated into a container

## KUBERNETES
- glossary: https://kubernetes.io/docs/reference/glossary/?fundamental=true
- https://kubernetes.io/docs/
- workload types: deployments(identity-less),statefulset(unique pods, persistent storage),daemonset(manages nodes)
- node: contains many pods, can be a virtual machine or physical machine
- containers in a pod share storage volumes and networking
    - each pod has a unique IP, containers in a prod share the IP address and network ports
        - containers in a pod can talk to each other using `localhost`
        - containers in same pod can use IPC like shared memory
- AWS eks permissions: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
