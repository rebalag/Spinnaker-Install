#!/bin/sh

printf "\n  [****] Starting the Distributed Spinnaker Lite Version Installation [****] "
printf '\n'
printf "\n  [****] Spinnaker would be installed in the Spinnaker Namespace which it would create by default [****] "
printf '\n'
#sleep 2

read -p "  [****] Enter the Docker registory/username [Ex: docker.io/opsmx11] :: " dockerusername
printf "\n"

printf '\n'

read -p "  [****] Enter the namespace where you want to deploy Spinnaker and Minio: " spinnaker_namespace

kubectl create namespace $spinnaker_namespace

#Setting up the Minio Storage for the Deployment
printf "\n  [****] Setting up the Storage for the Spinnaker Deployment [****]" 
printf '\n'
read -p "  [****] Enter the Minio Access Key [Access key length should be between minimum 3 characters in length] :: " access_key
read -p "  [****] Enter the Minio Secret Access Key [Secret key should be in between 8 and 40 characters] :: " secret_access_key
printf '\n'
printf "\n   [****]  Fetching and Updating the Minio Secret [****] "
printf '\n'
sed -i "s/MINIO_USER/$access_key/" minio_template.yml
sed -i "s/MINIO_PASSWORD/$secret_access_key/" minio_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" minio_template.yml
printf '\n'
printf '\n'
oc create  -f minio_template.yml

sed -i "s#example#$dockerusername#g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halconfigmap_template.yml

#Applying the Halyard Pod
printf "\n  [****] Configuring the Dependencies [****]"
printf '\n'
read -p "  [****] Enter the Spinnaker V2 Account Name to be configured :: " configmap_account

read -p "  [****] Enter the path of the Kube Config File :: " kube_path
#read -p "  [****] Enter the url for exposing the Gate [Ex: spin-gate.opsmx.com or ExternalIP:8084] :: " gateurl
#read -p "  [****] Enter the url for exposing the Deck [Ex: spin-deck.opsmx.com or ExternalIP:9000] :: " deckurl
#Updating the configs in the  Environment 

#Updating HalyardBomConfig And other configs

printf "\n  [****] Applying The Halyard local BOM [****] "
kubectl create configmap bomconfig --from-file=1.11.2/bom.yml -n $spinnaker_namespace

#cloudriver 
kubectl create  configmap clouddriverbomconfig -n $spinnaker_namespace --from-file=1.11.2/clouddriver.yml 

#deck
kubectl create configmap deckbomconfig -n $spinnaker_namespace --from-file=1.11.2/settings.js

#echo
kubectl create configmap echobomconfig -n $spinnaker_namespace --from-file=1.11.2/echo.yml 

#fiat
kubectl create configmap fiatbomconfig -n $spinnaker_namespace --from-file=1.11.2/fiat.yml

#front50
kubectl create configmap front50bomconfig -n $spinnaker_namespace --from-file=1.11.2/front50.yml

#gate
kubectl create configmap gatebomconfig -n $spinnaker_namespace --from-file=1.11.2/gate.yml

#igor
kubectl create configmap igorbomconfig -n $spinnaker_namespace --from-file=1.11.2/igor.yml

#orca
kubectl create configmap orcabomconfig -n $spinnaker_namespace --from-file=1.11.2/orca.yml

#rosco
kubectl create configmap roscobomconfig -n $spinnaker_namespace --from-file=1.11.2/rosco.yml
kubectl create configmap roscoimagebomconfig -n $spinnaker_namespace --from-file=1.11.2/images.yml
kubectl create configmap roscopackerbomconfig -n $spinnaker_namespace --from-file=packer.tar.gz

printf " \n  [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$configmap_account/g" halconfigmap_template.yml

sed -i "s/MINIO_USER/$access_key/" halconfigmap_template.yml
sed -i "s/MINIO_PASSWORD/$secret_access_key/" halconfigmap_template.yml
#sed -i "s/spin-gate.abc.com/$gateurl/" halconfigmap_template.yml
#sed -i "s/spin-deck.abc.com/$deckurl/" halconfigmap_template.yml

#applying halconfig template and Halyard Deployment Pod 

printf "\n  [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'
kubectl apply -f halconfigmap_template.yml 
kubectl create secret generic kubeconfig --from-file=$kube_path -n $spinnaker_namespace
kubectl apply -f halyard_template.yml 

printf "\n  [****]  Configuration is complete, please wait till for a few minutes before accessing the pod [****] "
printf '\n'
#rm -rf halyard_template.yml halconfigmap_template.yml minio-secret.yml minio.yml
printf "\n  [****]  Please use wait a minute and then execute the  command to check the Deployed 'spin-halyard' Pod 'kubectl get pods -n spinnaker' [*****]"
printf '\n'
printf "\n  [****]  Please do a 'hal deploy apply' from the pod that has been deployed [****] "
sleep 5
printf '\n'
