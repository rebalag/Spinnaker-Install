# Spinnaker Installation On Openshift Airgapped VM with Kubernetes V1 account

### Steps for Installing Spinnaker on Openshift

#### Prerequisites
      1. Airgapped VM with no connectivity to the outside world
      2. Openshift version v3.7, Kubernetes v1.7
      3. Bom images for all Spinnaker version 1.11.2 copied into the VM 
      4. Copy the files from the folder final dependencies into the VM
      
#### Steps:
      1. Run the script spinnaker_lite_install.sh and continue to provide inputs in the interactive session.
         This will spun up a minio storage pod along with a halyard pod with your inputs.
          $ sh spinnaker_lite_install.sh

      2. Once the halyard pod is up, do a "hal deploy apply" from inside the pod.
      
      That's it!! Spinnaker is up in your airgapped environment
