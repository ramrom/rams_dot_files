# DOCKER/KUBERNETES

## DOCKER
- good article on UID/GID user mapping
    - https://www.fullstaq.com/knowledge-hub/blogs/docker-and-the-host-filesystem-owner-matching-problem
### USAGE
- `docker ps` - list running containers
- `docker ps -a` - list containers in all states
- `docker compose -f some-compose-file.yml up -d` - native compose in docker cli
    - https://docs.docker.com/compose/reference/
    - `-d` runs without attaching it to the current shell
- `docker compose -f some-compose-file.yml pull` - pull the latest images
- `docker compose -f some-compose-file.yml pull fooserv` - pull only `fooserv`
- `docker compose -f some-compose-file.yml down --rmi all`
    - `down` stop containers, `--rmi all` removes all images specified in compose
- https://docs.docker.com/
- an image is built from the code in a Dockerfile
    - `docker build MyDockerfile`
    - `docker images` - list images
    - `docker create someimage` - create container from image
    - `docker rmi someimage`  - remove image
- a container is an instantiation of an image
    - `docker start somecontainer`, `docker restart somecontainer` - start/restart a container
    - `docker kill somecontainer`, `docker stop somecontainer` - stop = SIGTERM, kill = SIGKILL
    - `docker rm somecontainer` - delete the container
    - `docker inspect somecontainer` - json desc of configuration
- `sudo docker run -d -p 1111:1111 foo/image` - create a container and start it
    - `-d` is detach, wont run in foreground in shell
    - `-p x:x` is to map internal port to external port
- `sudo docker exec -it foocontainername /bin/bash` - start a bash shell in container
- `docker volume -qf dangling=true` - find dangling volumes
    - `docker volume rm $(docker volume ls -qf dangling=true)` - remove them
### UNDERLYING TECH
- `containerd` is a container runtime developed by Docker
    - uses linux cgroups to enforce limits CPU and memory
    - uses linux namespaces to isolate processes, filesystems, network, users(UIDs,GUID), env vars
### ISSUES
- symlinks in volumes that point to files in other volumes dont work
    - https://axell.dev/mounted-docker-volume-contains-symlinks/


## KUBERNETES
- supports many container runtimes including `containerd` and `CRI-O`
- glossary: https://kubernetes.io/docs/reference/glossary/?fundamental=true
- https://kubernetes.io/docs/
- workload types: deployments(identity-less),statefulset(unique pods, persistent storage),daemonset(manages nodes)
- pods have many containers, but typical setup is one container per pod
- each pod gets an IP
- node: contains many pods, can be a virtual machine or physical machine
- ingress rules describe routing and load balancing
    - needs an ingress controller, can use AWS, GCE, or nginx
- containers in a pod share storage volumes and networking
    - each pod has a unique IP, containers in a prod share the IP address and network ports
        - containers in a pod can talk to each other using `localhost`
        - containers in same pod can use IPC like shared memory
- AWS eks permissions: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
- tailing logs
    - `kubectl --namespace=foospace logs --follow mypod-fda234`

## COMPOSE
- `docker compose pull` - will get latest versions of images
- `--security-opt no-new-privileges` prevents things like a regular user sudo'ing as root in the container
- `priveleged_mode: true` - exposes a _lot_
    - can see every `/dev/` in the host, `fdisk -l` shows all host devices
    - good read https://learn.snyk.io/lessons/container-runs-in-privileged-mode/kubernetes/
        - container runtime does a lot shield container from host, this mode disables/bypasses most of these checks
        - so a root user in container has essentially root privs on host system
        - one legit use case for running nested docker, docker in a docker
- `network_mode: host` - copies host networking, `ifconfig` in container shows the exact same interfaces as on the host
