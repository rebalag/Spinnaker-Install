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
                2. Please change the username and password on the configmap

           Deploy Minio: 
                1. kubectl create -f minio_template.yml
                
         3. Create a configMap for the Kube config that would be mounted on the Halyard pod
         
                1. kubectl create configmap kubeconfig --from-file=$kube_path -n namespace
         
         4. Create a configMap for the Halyard config that would also be mounted on the Halyard Pod
            
            Please make sure you make to substitute the corresponding values where it has been commented on the config file that you have forked. Once done please proceed to create the configMap :
            
                1. kubectl create configmap halconfig --from-file=config -n namespace
                
         5. Deploy the halyard template 
            
            Please make sure you make these changes: 
                1. Specify the namespace where you want to deploy : namespace is mentioned on deployment & service
             
            Deploy Halyard: 
                 
                1. kubectl create -f halyard_template.yml
              
         6. Please do a "hal deploy apply" once the spin-halyard pod is in "ready" state
         
         
           

