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

# Build the test container
docker build -t notarysandbox .

####################################################################################################
#Obtain the seource code for notary and registry services. Use docker compose to build them
####################################################################################################

# Change to back to the root of your Notarysandbox directory
cd $curdir/notarysandbox

# Clone the Notary project
git clone -b trust-sandbox https://github.com/docker/notary.git

# Clone the distribution project.
git clone https://github.com/docker/distribution.git

# Build the server images
# docker-compose fails to build the notary-server
# cd notary && docker-compose build
# Start the server containers
# docker-compose up -d

exit

# We have a problem with Notary 1.0.rc1 as listed above so we use 0.5-dev
mkdir $curdir/notarysandbox/notary_0.5
cd $curdir/notarysandbox/notary_0.5  && git clone https://github.com/docker/notary.git && cd notary
docker-compose up -d

# Setup a local version of the Docker Registry v2
# Change to the notarysandbox/distribution directory and build sandboxy registry server


cd $curdir/notarysandbox/distribution && docker build -t sandboxregistry .

#Start the sandboxregistry server
docker run -p 5000:5000 --name sandboxregistry sandboxregistry &

# Start the notarysandbox and link it to the running notary_notaryserver_1 and  sandboxregistry containers.
# The links allow communication among the containers.
#docker run -it -v /var/run/docker.sock:/var/run/docker.sock --link notary_notaryserver_1:notaryserver --link sandboxreg
istry:sandboxregistry notarysandbox
docker run -it -v /var/run/docker.sock:/var/run/docker.sock --link notary_server_1:notary_server --link sandboxregistry:sandboxregistry notarysandbox


#To stop and cleanup
#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
