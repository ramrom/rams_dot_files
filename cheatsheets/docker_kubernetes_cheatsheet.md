# DOCKER/KUBERNETES

## DOCKER
- created around 2012, used [LXC](https://en.wikipedia.org/wiki/LXC) and runtime at first, then libcontainer(written in golang) later
- good article on UID/GID user mapping
    - https://www.fullstaq.com/knowledge-hub/blogs/docker-and-the-host-filesystem-owner-matching-problem
    - major point: the `UID` and `GUID` values in container will be identical to host for mapped drives
        - e.g. `UID` 1000 in container, owns file that's mapped to host, `UID` of file on host is also 1000
### DOCKER CLI
- `docker ps` - list running containers
- `docker ps -a` - list containers in all states
- https://docs.docker.com/
### DOCKER CLI IMAGES
- `docker build -f foo/MyDockerfile` - build from a Dockerfile with custom path/name
- `docker images` - list images
- `docker image history fooimage` - list the history of layers on image `fooimage`
    - a blank value in `CREATED_BY` column generally means it's manually commited changes from a container run
- `docker create someimage` - create container from image
- `docker rmi someimage`  - remove image
### DOCKER CLI CONTAINERS
- `docker container ls` - list running containers
    - `docker container ls -a` - list containers in all states
- `docker ps --format "table {{.Ports}}:\t {{.Names}}"` - print just ports/names of running containers
- `docker start somecontainer`, `docker restart somecontainer` - start/restart a container
- `docker kill somecontainer`, `docker stop somecontainer` - stop = SIGTERM, kill = SIGKILL
- `docker rm somecontainer` - delete the container
- `docker logs -f somecontainer` - `-f` follow the logs like `tail -f`
- `docker inspect somecontainer` - json desc of configuration
- `docker run -d -p 1111:1111 foo/image` - create a container and start it
    - `-d` is detach, wont run in foreground in shell
    - `-p x:x` is to map internal port to external port
    - `docker run --platform linux/amd64` - run the container on a specific platform
        - e.g. for errors like `The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)`
- `docker exec -it foocontainername /bin/bash` - start a bash shell in container
    - `docker run -d --entrypoint sleep YOUR_IMAGE 3600` - start a container with different entrypoint, `sleep` command here
        - this is a clever trick to start a container that can't start with it's existing entrypoint for whatever reason
- `docker volume -qf dangling=true` - find dangling volumes
    - `docker volume rm $(docker volume ls -qf dangling=true)` - remove them
### REGISTRIES
- `docker login foo.com` - login to a docker registry
    - `~/.docker/config.json` will show list of sessions for registries
    - OSX error: `exec: "docker-credential-desktop.exe": executable file not found in $PATH`
        - see https://stackoverflow.com/questions/65896681/exec-docker-credential-desktop-exe-executable-file-not-found-in-path
            - renaming `credsStore` to `credStore` worked fine
- add mirrors - see https://docs.docker.com/docker-hub/mirror/
    - can start dockerd with `--registry` or manually add to `~/.docker/daemon.json`
### SECURITY
- `priveleged_mode: true` - exposes a _lot_
    - can see every `/dev/` in the host, `fdisk -l` shows all host devices
    - good read https://learn.snyk.io/lessons/container-runs-in-privileged-mode/kubernetes/
        - container runtime does a lot shield container from host, this mode disables/bypasses most of these checks
        - so a root user in container has essentially root privs on host system
        - one legit use case for running nested docker, docker in a docker
- `--security-opt no-new-privileges` prevents things like a regular user sudo'ing as root in the container
### NETWORK
- `network_mode: bridged`(compose syntax) mode - use a private network created in docker
- `network_mode: host` - copies host networking, `ifconfig` in container shows the exact same interfaces as on the host
- `ports` - specify just some ports to be exposed to host
### UNDERLYING TECH
- `Dockerfile` - a file specifying how to build an image
    - must have entry point, basically the shell command that will run when container starts
- image - represents an immutable state
    - it's composed of layers and you cant modify existing layers
    - can create new changes on top of it and save them, this adds a layer, can also create a new image that points to a layer
    - can instantiate an image as a container
        - as the container runs it adds changes, can commit those changes to a new layer
        - `Dockerfile`s used to create new images, results from each command basically become a new layer
    - creating a root base image: https://docs.docker.com/build/building/base-images/
- container - an instantiation of an image
    - can spawn many containers from the same image
    - can use `docker container commit` to save containers state as a new image layer
        - in practice this is rarely done, `Dockefile`s are used to create the layers
- docker uses linux kernel to manage resources, for osx docker uses a linux VM layer in order to run, so inherently worse
    - since 2016 - uses apple hyperkit to run a linux vm, and it's integrated into the docker desktop package
    - before 2016 - used virtualbox to run a linux vm
- `containerd` is a container runtime developed by Docker
    - uses linux cgroups to enforce limits CPU and memory
    - uses linux namespaces to isolate processes, filesystems, network, users(UIDs,GUID), env vars
    - talked to `runc` to for running containers using a shim process
### PACKAGES
- buildx - docker cli plugin that uses BuildKit under the hood to build images with `docker build`
    - old docker versions(of cli i think) you did `docker buildx build`
    - buildx is sophisticated, and has a builder concept it supports: https://docs.docker.com/build/architecture/#builders
- docker engine is the main package - https://docs.docker.com/engine
    - includes: core daemon process is `dockerd`, cli tool, APIs
    - docker engine API(REST) docs: https://docs.docker.com/engine/api/
        - cli uses API to talk to `dockerd`
        - `dockerd` daemon talks grpc to `containerd`
- docker desktop - docker engine + extra tooling (Docker Build, Docker Extensions, Docker Compose, Kubernetes, cred helper)
- [colima](https://github.com/abiosoft/colima) - co(container) for lima
    - a runtime for containers, supports docker, supports osx(Mx/arm and x86/64)/linux
    - [uses LIMA](https://github.com/lima-vm/lima), linux VMs for macOS, but supports netBSD and others
### ISSUES
- symlinks in volumes that point to files in other volumes dont work
    - https://axell.dev/mounted-docker-volume-contains-symlinks/

## DOCKER COMPOSE
- `docker compose pull` - will get latest versions of images
- `docker compose -f some-compose-file.yml up -d` - native compose in docker cli
    - https://docs.docker.com/compose/reference/
    - `-d` runs without attaching it to the current shell
- `docker compose -f some-compose-file.yml pull` - pull the latest images
- `docker compose -f some-compose-file.yml pull fooserv` - pull only `fooserv`
- `docker compose -f some-compose-file.yml down --rmi all`
    - `down` stop containers, `--rmi all` removes all images specified in compose

## KUBERNETES
- means "helmsman" or "pilot" in ancient greek
- designed by google in 2014, written in golang, opensource(apache 2.0 liscense), maintained by cloud native compute foundation
    - based off google [borg](https://research.google/pubs/pub43438/)
- supports many container runtimes including `containerd` and `CRI-O`
- glossary: https://kubernetes.io/docs/reference/glossary/?fundamental=true
- https://kubernetes.io/docs/
- workload types
    - replicaset - stateless pods, pods can be killed and spawned
        - generally use deployments to specify and manage a replicaset
    - statefulset - stateful pods, persistent storage, has sticky identity
    - daemonset - ensure one pod per node, node-local facilities
        - e.g. log collection/aggregator pod, metrics collection/aggregator pod
    - jobs - one off tasks that complete and then stop
        - job tracks successful completions, when a specified number is reached, job finishes
    - cronjobs - recurring jobs on schedule
- AWS eks permissions: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
- liveliness vs readiness
    - liveliness - verify pod is running, app/process didnt deadlock or crash or run out of memory, so cant respond to requests
        - k8 will generally restart pod
    - readiness - pod could be live but not ready to receive traffic yet, e.g. waiting for other pods/services, or populating dataset
        - k8 will just stop serving traffic to pod (but wont kill/restart it)
- DEPLOY TYPES
    - recreate -> all pods are updated at the same time
    - rolling -> one pod is updated at a time
    - blue/green -> deploy new versions to a seperate cluster, switch DNS to it
    - canary -> see https://kubernetes.io/docs/concepts/workloads/management/#canary-deployments
        - this is basic, lets u have both vers at the same time, if x of y total are new version, then x/y percent reqs goto new ver
- HPA - horizontal pod autoscaler - rules for min pods, max pods
- DEPLOYMENT - declarative updates for pods and replicasets
    - main rules: ingress routing, vertical scaling, env vars, etc
    - dont include HPA
- istio -> service mesh for kubernetes that lets you do cool things like complicated canary deploys
### ARCHITECTURE
- CLUSTER NETWORK
    - main article - https://kubernetes.io/docs/concepts/cluster-administration/networking/
- CLUSTER - an instance of a kubernetes system
    - has a control plane and composed of many nodes
    - all pods/containers talk to each other internally via a virtual network
- NODE - contains many pods, can be a virtual machine or physical machine
- POD - a deployable entity
    - have many containers, but typical setup is one container per pod
    - containers in a pod share storage volumes and networking
    - each pod has a unique IP, containers in a pod share the IP address and network ports
        - containers in a pod can talk to each other using `localhost`
        - containers in same pod can use IPC like shared memory
- SERVICE - identifies a set of pods as a logical "service"
    - docs: https://kubernetes.io/docs/concepts/services-networking/service/
    - groups of pods are identified using labels or selectors (e.g. service `fooservice` adds all pods with label `foo`)
    - have VIPs only routable within cluster network
    - VIP and DNS is stable, pods don't have stable IPs
- INGRESS - rules to describe routing for traffic from outside cluster into services
    - ingress controllers can also load balance and do TLS/SSL termination
    - needs an ingress controller, can use AWS, GCE, or nginx
- GATEWAY - https://gateway-api.sigs.k8s.io/
    - API to kinda replace/complement ingress/service-mesh/LB
- KUBELET - a agent that lives in each node, manages that node and communicates with control plane
- CONTROL PLANE - orchestrates and manages the entire cluster, talks to the kubelets
    - API server - communication hub, all clients talk to it, including CLI tools, GUI admin tools, and pods and kubelets in cluster
    - controller manager - manages the desired state of cluster by monitoring the cluster
    - scheduler - figures out where to deploy new pods based on requirements and availability
    - etcd - key/value store - persistent stores all config data, real time status of nodes/pods
- can deploy multiple control planes for HA in production
### CLI
- `kubectl config get-contexts` - print session contexts
- `kubectl config use-context foobar` - set current context
- `kubectl config current-context` - print current context
- `kubectl delete pods foopodname` - terminate a pod
- `kubectl get pods` - print pods, _NOTE_ only prints in default namespace
    - `kubectl get pods --all-namespaces` - print pods in all namespaces
- events (e.g. HPA actions, ingress rule reloads, pod delete/restart actions, pulling images, etc.)
    - `kubectl events --all-namespaces` - print all events(tons of stuff)
    - `kubectl events -n foospace` - for a namespace 
    - `kubectl events --for somepod --watch` - for a pod and continue to watch and print to shell
    - `kubectl events --types=Warning,Normal` - only show events of warning and normal
- tailing logs
    - `kubectl --namespace=foospace logs --follow mypod-fda234`
- copy a file from pod to local machine
    - `kubectl cp <pod-name>:<some-file> <our local destination directory>`
- port-forward to a pod
    - `kubectl port-forward -n core svc/myservice-svc 8080:80` - this forwards remote 80 to local 8080
        - if webservice then `curl localhost:8080/myservice/someendpoint`
- get _all_ deployment info in json: `kubectl get deployments --all-namespaces -o json`
- `kubectl get hpa --all-namespaces` - get hpa status on all pods
### K9S
- awesome TUI for kubernetes
- learn to use https://github.com/derailed/k9s
- type `namespaces` and select one or `all` to see all pods
- restart kn9 to see any new EKS sessions created during the kn9 session when issuing `context` command to switch
- keys:
    - ctrl f/b page forward/backward like vim
- `pulse` is a real-time time-series bar graph overview
- `xray` tree view of resource and deps
- `rb` see authorizations


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
