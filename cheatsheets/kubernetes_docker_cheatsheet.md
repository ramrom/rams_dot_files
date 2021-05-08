# KUBERNETES
- each pod gets an IP
- pods have many containers, but typical setup is one container per pod
- deployment files fully describe rules
- ingress rules describe routing and load balancing
    - needs an ingress controller, can use AWS, GCE, or nginx

# DOCKER
- Dockerfile specifes how to build a image
- an image is "instantiated" into a container, which stores current state
