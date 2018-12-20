# Spinnaker On Kubernetes

### Steps for Installing Spinnaker on Kubernetes

#### Prerequisites
        1. VM with Kubectl binary installed 
        2. Kube Config file of the Kubernetes 

#### Steps: 
        1. Install Kubectl 

                $ curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
                $ chmod +x ./kubectl
                $ sudo mv ./kubectl /usr/local/bin/kubectl
                
        2. Create the Minio Deployment with service and ConfigMap
           Please make sure you make these changes: 
                1. Specify the namespace where you want to deploy : namespace is mentioned on deployment, service, configmap

