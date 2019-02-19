#!/bin/bash

## Company : OpsMx
## Author : Gnana Seelan
echo "Current Time is : $(date)"


echo The Spinnaker will be deployed in : $6 platform
# echo The Minio PVC Size: $3

echo The Namespace where you want to Deploy the Spinnaker and its Related Service is : $5


kubectl create namespace $5

if [ $? == 0 ]
then
echo $5 Namespace is created sucessfully
else
echo $5 Namespace not created. Kindly make sure kubectl binary should be available.
exit
fi

oc adm policy add-scc-to-user anyuid -z default -n $5
# echo $? #######
dockerusername="docker.io/opsmx11"

echo Enter the Docker registory/username [Ex: docker.io/opsmx11] :: $dockerusername

#Setting up the Minio Storage for the Deployment

echo Enter the Minio Access Key [Access key length should be between minimum 3 characters in length] :: $4
printf '\n'
echo Enter the Minio Secret Access Key [Secret key should be in between 8 and 40 characters] :: $1
printf '\n'
base1=$(echo -ne "$4" |base64)
base2=$(echo -ne "$1" |base64)

printf "\n [****] Fetching and Updating the Minio Secret [****] "
printf '\n'

curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install-4oes/minio_template4oes.yml -o minio_template.yml

if [ $? == 0 ]
then
echo minio_template.yml file is downloaded successfully
else
echo Kindly ensure curl command should be available.
exit
fi

printf '\n'
sed -i "s/base64convertedaccesskey/$base1/" minio_template.yml
sed -i "s/base64convertedSecretAccesskey/$base2/" minio_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" minio_template.yml
sed -i "s/MINIO_STORAGE/$3/g" minio_template.yml

kubectl create -n $5 -f minio_template.yml

if [ $? == 0 ]
then
echo Minio deployed successfully
else
echo Minio deployment failed
fi

curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install-4oes/halyard_template4oes.yml -o halyard_template.yml

printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install-4oes/halconfigmap_template4oes.yml -o halconfigmap_template.yml

printf '\n'
# pulling and pushing images
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/master/spinnaker-oc-install-4oes/extract.py -o extract.py

python extract.py $dockerusername

sed -i "s#example#$dockerusername#g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_VERSION/$7/g" halconfigmap_template.yml

# Applying the Halyard Pod
printf "\n [****] Configuring the Dependencies [****]"
printf '\n'

configmap_account=Kubernetes-v2
echo Enter the Spinnaker V2 Account Name to be configured :: $configmap_account

printf '\n'
echo Enter the path of the Kube Config File :: $2

#Updating the configs in the Environment 
printf '\n'
printf " \n [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$configmap_account/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halconfigmap_template.yml
sed -i "s/MINIO_USER/$4/" halconfigmap_template.yml
sed -i "s/MINIO_PASSWORD/$1/" halconfigmap_template.yml

printf '\n'

printf "\n [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'
kubectl apply -f halconfigmap_template.yml -n $5
sleep 5
kubectl create secret generic kubeconfig --from-file=$2 -n $5
sleep 5
kubectl apply -f halyard_template.yml -n $5

sleep 180 # Waiting for halyard pod to come up 

current_status=`oc get pods | grep spin-halyard | awk '{print $3}'`

if [ $current_status == Running ]
then
oc project -n $1
halyard_podname=`oc get pods | grep spin-halyard | awk '{print $1}'`
echo $halyard_podname
oc exec -it $halyard_podname /bin/bash

hal config version edit --version $7
hal deploy apply
else
echo Halyard pod is not comming up
fi
