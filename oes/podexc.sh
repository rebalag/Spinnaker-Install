#!/bin/bash

## Company : OpsMx
## Author : Gnana Seelan
echo  "Current Time is :  $(date)"


current_status=`oc get pods | grep spin-halyard | awk '{print $3}'`

if [ $current_status == Running ]
then
        oc project -n $1
        halyard_podname=`oc get pods | grep spin-halyard | awk '{print $1}'`
        echo $halyard_podmane
        oc exec -it  $halyard_podname /bin/bash
        hal config version edit --version 1.12.1
        # hal deploy apply -n $1
else
   echo Halyard pod is not comming up
fi
