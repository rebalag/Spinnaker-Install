#!/bin/sh

printf "\n  [****] Starting the Distributed Spinnaker Lite Version Installation [****] "
printf '\n'
printf "\n  [****] Spinnaker would be installed in the Spinnaker Namespace which it would create by default [****] "
printf '\n'
sleep 2
kubectl create namespace spinnaker
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
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/minio-secret.yml -o minio-secret.yml
printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/minio.yml -o minio.yml
printf '\n'
sed -i "s/base64convertedaccesskey/$base1/" minio-secret.yml
sed -i "s/base64convertedSecretAccesskey/$base2/" minio-secret.yml
kubectl create -n spinnaker -f minio-secret.yml
kubectl create -n spinnaker -f minio.yml

#Fork the files from Github
printf "\n  [****] Fetching the files for the Halyard Template and the ConfigMap for the deployment  [****]" 
printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/halconfigmap_template.yml -o halconfigmap_template.yml
printf '\n' 
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install/halyard_template.yml -o halyard_template.yml
printf '\n'

#Applying the Halyard Pod
printf "\n  [****] Configuring the Dependencies [****]"
printf '\n'
read -p "  [****] Enter the Spinnaker V2 Account Name to be configured :: " configmap_account
#read -p "  [****] Enter the Docker username :: " dockerusername
#read -sp "  [****] Enter the Docker password :: " dockerpassword
#printf "\n"
#read -p "  [****] Enter the Docker repository :: " dockerrepo
#read -p "  [****] Enter the Minio Endpoint :: " minioEndpoint
read -p "  [****] Enter the path of the Kube Config File :: " kube_path
#read -p "  [****] Enter the url for exposing the Gate [Ex: spin-gate.opsmx.com or ExternalIP:8084] :: " gateurl
#read -p "  [****] Enter the url for exposing the Deck [Ex: spin-deck.opsmx.com or ExternalIP:9000] :: " deckurl
#Updating the configs in the  Environment 

printf " \n  [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$configmap_account/g" halconfigmap_template.yml
#sed -i "s/docker_repo_username/$dockerusername/" halconfigmap_template.yml
#sed -i "s/docker_repo_password/$dockerpassword/" halconfigmap_template.yml
#sed -i "s/docker_repo/$dockerrepo/" halconfigmap_template.yml#
#sed -i "s/minio_endpoint/minioEndpoint/" halconfigmap_template.yml
#sed -i "s/us-west-2/$region/" halconfigmap_template.yml
sed -i "s/opsmx123456/$access_key/" halconfigmap_template.yml
sed -i "s/opsmx_123456/$secret_access_key/" halconfigmap_template.yml
#sed -i "s/spin-gate.abc.com/$gateurl/" halconfigmap_template.yml
#sed -i "s/spin-deck.abc.com/$deckurl/" halconfigmap_template.yml
#Applying Halconfig template and Halyard Deployment Pod 

printf "\n  [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'
kubectl apply -f halconfigmap_template.yml -n spinnaker
kubectl create secret generic kubeconfig --from-file=$kube_path -n spinnaker
kubectl apply -f halyard_template.yml -n spinnaker

printf "\n  [****]  Configuration is complete, please wait till for a few minutes before accessing the pod [****] "
printf '\n'
rm -rf halyard_template.yml halconfigmap_template.yml minio-secret.yml minio.yml
printf "\n  [****]  Please use wait a minute and then execute the  command to check the Deployed 'spin-halyard' Pod 'kubectl get pods -n spinnaker' [*****]"
printf '\n'
printf "\n  [****]  Please do a 'hal deploy apply' from the pod that has been deployed [****] "
sleep 5
printf '\n'
