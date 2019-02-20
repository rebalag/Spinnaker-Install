#!/bin/sh

printf "\n  [****] Starting the Distributed Spinnaker Lite Version Installation [****] "
printf '\n'
printf "\n  [****] Spinnaker would be installed in the Spinnaker Namespace which it would create by default [****] "
printf '\n'
printf "\n  [****] Please ensure you have a docker login for pushing the script to customized repository [****] "

#checking for Docker UserName and Password for pushing the Docker images using extract.py, if extract.py is not in use we don't require docker login
read -p "  [****] Enter the Docker registory/username [Ex: docker.io/opsmx11] :: " dockerusername
#read -sp "  [****] Enter the Docker password :: " dockerpassword
printf "\n"

printf '\n'
read -p "  [****] Enter the Namespace where you want to Deploy Spinnaker and related services :" spinnaker_namespace


oc create namespace $spinnaker_namespace

#Adding root permissions to the service accounts
oc adm policy add-scc-to-user anyuid -z default -n $spinnaker_namespace
oc adm policy add-scc-to-user anyuid -z builder -n $spinnaker_namespace
oc adm policy add-scc-to-user anyuid -z deployer -n $spinnaker_namespace
oc adm policy add-scc-to-user anyuid -z spinnaker -n $spinnaker_namespace


#Setting up the Minio Storage for the Deployment
printf "\n  [****] Setting up the Storage for the Spinnaker Deployment [****]" 
printf '\n'
read -p "  [****] Enter the Minio Access Key [Access key length should be between minimum 3 characters in length] :: " access_key
read -p "  [****] Enter the Minio Secret Access Key [Secret key should be in between 8 and 40 characters] :: " secret_access_key
printf '\n'
base1=$(echo -ne "$access_key" |base64)
base2=$(echo -ne "$secret_access_key" |base64)
printf "\n   [****]  Fetching and Updating the Minio Secret [****] "
printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/minio_template.yml -o minio_template.yml
printf '\n'
sed -i "s/base64convertedaccesskey/$base1/" minio_template.yml
sed -i "s/base64convertedSecretAccesskey/$base2/" minio_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" minio_template.yml
oc create -n $spinnaker_namespace -f minio_template.yml

#Fork the files from Github
printf "\n  [****] Fetching the files for the Halyard Template and the ConfigMap for the deployment  [****]" 
printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/halconfigmap_template.yml -o halconfigmap_template.yml
printf '\n' 
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/halyard_template.yml -o halyard_template.yml
printf '\n'

# pulling and pushing images
#curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/extract.py -o extract.py
#printf '\n'
#python extract.py $dockerusername

#changing the values in halyard-template and halconfig

sed -i "s#example#$dockerusername#g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halconfigmap_template.yml

#Applying the Halyard Pod
printf "\n  [****] Configuring the Dependencies [****]"
printf '\n'
read -p "  [****] Enter the Spinnaker V2 Account Name to be configured :: " configmap_account
read -p "  [****] Enter the path of the Kube Config File :: " kube_path

#Updating the configs in the  Environment 

printf " \n  [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$configmap_account/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$spinnaker_namespace/g" halconfigmap_template.yml
sed -i "s/MINIO_USER/$access_key/" halconfigmap_template.yml
sed -i "s/MINIO_PASSWORD/$secret_access_key/" halconfigmap_template.yml


printf "\n  [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'
oc apply -f halconfigmap_template.yml -n $spinnaker_namespace
oc create secret generic kubeconfig --from-file=$kube_path -n $spinnaker_namespace
oc apply -f halyard_template.yml -n $spinnaker_namespace

printf "\n  [****]  Configuration is complete, please wait till for a few minutes before accessing the pod [****] "
printf '\n'
#rm -rf halyard_template.yml halconfigmap_template.yml minio-secret.yml minio.yml
printf "\n  [****]  Please use wait a minute and then execute the  command to check the Deployed 'spin-halyard' Pod 'oc get pods -n spinnaker' [*****]"
printf '\n'
printf "\n  [****]  Please do a 'hal deploy apply' from the pod that has been deployed [****] "
sleep 5
printf '\n'
