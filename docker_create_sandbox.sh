#!/bin/sh
# The script below, with minor modifications, are obtained from: http://54.71.194.30:4111/engine/security/trust/trust_sandbox/ 
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
cp $curdir/Dockerfile .

exit


# Build the test container
docker build -t notarysandbox .

# Change to back to the root of your Notarysandbox directory
cd $curdir/notarysandbox

# Clone the Notary project
git clone -b trust-sandbox https://github.com/docker/notary.git

# Clone the distribution project.
git clone https://github.com/docker/distribution.git

# Setup a local version of the Docker Registry v2
# Change to the notarysandbox/distribution directory.
cd $curdir/notarysandbox/distribution

# Build the sandboxregistry server
docker build -t sandboxregistry .

#Start the sandboxregistry server
docker run -p 5000:5000 --name sandboxregistry sandboxregistry &

# Start the notarysandbox and link it to the running notary_notaryserver_1 and  sandboxregistry containers. The links allow communication among the containers.
docker run -it -v /var/run/docker.sock:/var/run/docker.sock --link notary_notaryserver_1:notaryserver --link sandboxregistry:sandboxregistry notarysandbox


