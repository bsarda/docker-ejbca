#!/bin/sh
docker ps -a | grep bsarda/ejbca | awk '{print $1}' | xargs -n1 docker rm -f
docker rmi bsarda/ejbca:latest
docker rmi bsarda/ejbca:6.3.1

docker build -t bsarda/ejbca .
docker tag bsarda/ejbca bsarda/ejbca:latest
docker tag bsarda/ejbca bsarda/ejbca:6.3.1
