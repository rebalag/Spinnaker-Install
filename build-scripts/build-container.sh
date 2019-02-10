#!/bin/bash
if [ -z $1 ]
then
  echo 'Usage: buildcontainer.sh <docker repo name> <spinnaker version>'
  exit 1
fi
if [ -z $2 ]
then
  echo 'Usage: buildcontainer.sh <docker repo name> <spinnaker version>'
  exit 1
fi
cd clouddriver
sudo docker build -t $1/clouddriver:$2 -f Dockerfile.slim .
sudo docker push $1/clouddriver:$2
cd ..
cd gate
sudo docker build -t $1/gate:$2 -f Dockerfile.slim .
sudo docker push $1/gate:$2
cd ..
cd deck
sudo docker build -t $1/deck:$2 -f Dockerfile.slim .
sudo docker push $1/deck:$2
cd ..
cd fiat
sudo docker build -t $1/fiat:$2 -f Dockerfile.slim .
sudo docker push $1/fiat:$2
cd ..
cd orca
sudo docker build -t $1/orca:$2 -f Dockerfile.slim .
sudo docker push $1/orca:$2
cd ..
cd rosco
sudo docker build -t $1/rosco:$2 -f Dockerfile.slim .
sudo docker push $1/rosco:$2
cd ..
cd igor
sudo docker build -t $1/igor:$2 -f Dockerfile.slim .
sudo docker push $1/igor:$2
cd ..
cd kayenta
sudo docker build -t $1/kayenta:$2 -f Dockerfile.slim .
sudo docker push $1/kayenta:$2
cd ..
cd halyard
sudo docker build -t $1/halyard:$2 -f Dockerfile.local .
sudo docker push $1/halyard:$2
cd ..
cd front50
sudo docker build -t $1/front50:$2 -f Dockerfile.slim .
sudo docker push $1/front50:$2
cd ..
cd echo
sudo docker build -t $1/echo:$2 -f Dockerfile.slim .
sudo docker push $1/echo:$2
cd ..
