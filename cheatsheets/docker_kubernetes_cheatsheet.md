# DOCKER/KUBERNETES

## DOCKER
- created around 2012, used LXC and runtime at first, then libcontainer(written in golang) later
- good article on UID/GID user mapping
    - https://www.fullstaq.com/knowledge-hub/blogs/docker-and-the-host-filesystem-owner-matching-problem
### USAGE
- `docker ps` - list running containers
- `docker ps -a` - list containers in all states
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
- `docker login foo.com` - login to a docker registry
    - `~/.docker/config.json` will show list of sessions for registries
### UNDERLYING TECH
- docker uses linux kernel to manage resources, for osx docker uses a linux VM layer in order to run, so inherently worse
    - since 2016 - uses apple hyperkit to run a linux vm, and it's integrated into the docker desktop package
    - before 2016 - used virtualbox to run a linux vm
- docker engine is the main package - https://docs.docker.com/engine
    - includes: core daemon process is `dockerd`, cli tool, APIs
    - docker engine API(REST) docs: https://docs.docker.com/engine/api/
        - cli uses API to talk to `dockerd`
        - `dockerd` daemon talks grpc to `containerd`
- `containerd` is a container runtime developed by Docker
    - uses linux cgroups to enforce limits CPU and memory
    - uses linux namespaces to isolate processes, filesystems, network, users(UIDs,GUID), env vars
    - talked to `runc` to for running containers using a shim process
### ISSUES
- symlinks in volumes that point to files in other volumes dont work
    - https://axell.dev/mounted-docker-volume-contains-symlinks/


## KUBERNETES
- means "helmsman" or "pilot" in ancient greek
- designed by google in 2014, written in golang, opensource(apache 2.0 liscense), maintained by cloud native compute foundation
    - based off google [borg](https://research.google/pubs/pub43438/)
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
- HPA - horizontal pod autoscaler
    - rules for min pods, max pods
    - `kubectl get hpa --all-namespaces` - get hpa status on all pods
- `deployments`
    - main rules: ingress routing, vertical scaling, env vars, etc
    - dont include HPA
- deploys
    - recreate -> all pods are updated at the same time
    - rolling -> one pod is updated at a time
    - blue/green -> deploy new versions to a seperate cluster, switch DNS to it
    - canary -> see https://kubernetes.io/docs/concepts/workloads/management/#canary-deployments
        - this is basic, lets u have both vers at the same time, if x of y total are new version, then x/y percent reqs goto new ver
- istio -> service mesh for kubernetes that lets you do cool things like complicated canary deploys

## HELM
- package manager and configuration for kubernetes
    - package kubernetes YAML files and distribute them publicly or privately
    - Helm repositories used to store helm charts
- helm chart -> a bundle of YAML files
- has a CLI, can search for packages e.g. `helm search <keyword>`
- also supports templating
    - templates use variables that pull values from a Values YAML file
- helm v2.0 has server-client arch, server(Tiller) and client(helm CLI)
    - used for release management
    - stores chart histories and executions

## COMPOSE
- `docker compose pull` - will get latest versions of images
- `docker compose -f some-compose-file.yml up -d` - native compose in docker cli
    - https://docs.docker.com/compose/reference/
    - `-d` runs without attaching it to the current shell
- `docker compose -f some-compose-file.yml pull` - pull the latest images
- `docker compose -f some-compose-file.yml pull fooserv` - pull only `fooserv`
- `docker compose -f some-compose-file.yml down --rmi all`
    - `down` stop containers, `--rmi all` removes all images specified in compose
- `--security-opt no-new-privileges` prevents things like a regular user sudo'ing as root in the container
- `priveleged_mode: true` - exposes a _lot_
    - can see every `/dev/` in the host, `fdisk -l` shows all host devices
    - good read https://learn.snyk.io/lessons/container-runs-in-privileged-mode/kubernetes/
        - container runtime does a lot shield container from host, this mode disables/bypasses most of these checks
        - so a root user in container has essentially root privs on host system
        - one legit use case for running nested docker, docker in a docker
- `network_mode: host` - copies host networking, `ifconfig` in container shows the exact same interfaces as on the host
