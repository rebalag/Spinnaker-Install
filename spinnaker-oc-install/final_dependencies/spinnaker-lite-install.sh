#!/bin/sh

printf "\n  [****] Starting the Distributed Spinnaker Lite Version Installation [****] "
printf '\n'
printf "\n  [****] Spinnaker would be installed in the Spinnaker Namespace which it would create by default [****] "
printf '\n'
#sleep 2

#Reading the namespace to deploy the Spinnaker and Minio
read -p "  [****] Enter the namespace where you want to deploy Spinnaker and Minio: " spinnaker_namespace
oc create namespace $spinnaker_namespace
oc adm policy add-scc-to-user anyuid -z default -n $spinnaker_namespace
oc adm policy add-scc-to-user anyuid -z builder -n $spinnaker_namespace

#Reading the Username and Repository for Docker
read -p "  [****] Enter the Docker registory/username [Ex: docker.io/opsmx11] :: " dockerrepoName
printf '\n'

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
sed -i "s#example#$dockerrepoName#g" minio_template.yml
printf '\n'
oc create  -f minio_template.yml

oc adm policy remove-scc-from-user anyuid -z default -n $spinnaker_namespace
oc adm policy remove-scc-from-user anyuid -z builder -n $spinnaker_namespace

#Replacing the Spinnaker Namespace in halyard
sed -i "s#example#$dockerrepoName#g" halyard_template.yml
sed -i "s#example#$dockerrepoName#g" halconfigmap_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halconfigmap_template.yml

#Applying the Halyard Pod
printf "\n  [****] Configuring the Dependencies [****]"
printf '\n'
read -p "  [****] Enter the Spinnaker Docker Account Name to be configured :: "  docker_configmap_account
printf '\n'
read -p "  [****] Enter the Spinnaker V1 Account Name to be configured :: " configmap_account
printf '\n'
read -p "  [****] Enter the path of the Kube Config File :: " kube_path

#Updating HalyardBomConfig And other configs
printf "\n  [****] Applying The Halyard local BOM [****] "
oc create configmap bomconfig --from-file=1.11.2/bom.yml -n $spinnaker_namespace

#cloudriver 
oc create  configmap clouddriverbomconfig -n $spinnaker_namespace --from-file=1.11.2/clouddriver.yml 
#oc create  configmap clouddriverbootstrapbomconfig -n $spinnaker_namespace --from-file=1.11.2/clouddriver.yml 
#deck
oc create configmap deckbomconfig -n $spinnaker_namespace --from-file=1.11.2/settings.js

#echo
oc create configmap echobomconfig -n $spinnaker_namespace --from-file=1.11.2/echo.yml 

#fiat
oc create configmap fiatbomconfig -n $spinnaker_namespace --from-file=1.11.2/fiat.yml

#front50
oc create configmap front50bomconfig -n $spinnaker_namespace --from-file=1.11.2/front50.yml

#gate
oc create configmap gatebomconfig -n $spinnaker_namespace --from-file=1.11.2/gate.yml

#igor
oc create configmap igorbomconfig -n $spinnaker_namespace --from-file=1.11.2/igor.yml

#orca
oc create configmap orcabomconfig -n $spinnaker_namespace --from-file=1.11.2/orca.yml
#oc create configmap orcabootstrapbomconfig -n $spinnaker_namespace --from-file=1.11.2/orca.yml

#rosco
oc create configmap roscobomconfig -n $spinnaker_namespace --from-file=1.11.2/rosco.yml
oc create configmap roscoimagebomconfig -n $spinnaker_namespace --from-file=1.11.2/images.yml
oc create configmap roscopackerbomconfig -n $spinnaker_namespace --from-file=packer.tar.gz

printf " \n  [****] Updating configmap [****]" 
sed -i "s#DOCKER_SPINNAKER#$docker_configmap_account#g"  halconfigmap_template.yml
sed -i "s/SPINNAKER_ACCOUNT/$configmap_account/g" halconfigmap_template.yml

sed -i "s/MINIO_USER/$access_key/" halconfigmap_template.yml
sed -i "s/MINIO_PASSWORD/$secret_access_key/" halconfigmap_template.yml

#Applying halconfig template and Halyard Deployment Pod 

printf "\n  [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'
oc create secret generic kubeconfig --from-file=$kube_path -n $spinnaker_namespace
oc create -f halconfigmap_template.yml
oc create -f halyard_template.yml 

printf "\n  [****]  Configuration is complete, please wait till for a few minutes before accessing the pod [****] "
printf '\n'
printf "\n  [****]  Please use wait a minute and then execute the  command to check the Deployed 'spin-halyard' Pod 'oc get pods -n spinnaker' [*****]"
printf '\n'
printf "\n  [****]  Please do a 'hal deploy apply' from the pod that has been deployed [****] "
sleep 5
printf '\n'
