#!/bin/sh

# The script below, with minor modifications, are obtained from: https://docs.docker.com/engine/security/trust/trust_sandbox/ 
# It  set up and use a sandbox for experimenting with trust. 
# The sandbox allows you to configure and try trust operations locally without impacting your production images
# This sandbox requires you to install two Docker tools: Docker Engine and Docker Compose.
# The sandbox’ notaryserver and sandboxregistry run on your local server. 
# The client inside the notarysandbox container connects to them over your network.
# For more information see: http://54.71.194.30:4111/engine/security/trust/trust_sandbox/ 


#Add an entry for the notaryserver to /etc/hosts:
sudo sh -c 'echo "127.0.0.1 notaryserver" >> /etc/hosts'

#Add an entry for the sandboxregistry to /etc/hosts
sudo sh -c 'echo "127.0.0.1 sandboxregistry" >> /etc/hosts'

#Make the notarysandbox/notarytest directory structure
curdir=`pwd`

mkdir notarysandbox && cd notarysandbox && mkdir notarytest && cd notarytest
cp $curdir/docker-compose_v3.yml docker-compose.yml
cp -r $curdir/notarycerts .

# Run the containers 
#docker-compose up -d

docker-compose up 

