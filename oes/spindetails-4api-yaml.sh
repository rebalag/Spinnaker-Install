#!/bin/bash


all11=`hal version bom | grep -m11 version:`

spin_version=`hal version bom | grep -m1 version: | awk '{printf $2}'`


Echo=`echo $all11 | awk '{printf  $4}'`

Clouddriver=`echo $all11 | awk '{printf    $6}'`

Deck=`echo $all11 | awk '{printf   $8}'`

Fiat=`echo $all11 | awk '{printf   $10}'`

Front50=`echo $all11 | awk '{printf  $12}'`

Gate=`echo $all11 | awk '{printf  $14}'`

Igor=`echo $all11 | awk '{printf  $16}'`

Kayenta=`echo $all11 | awk '{printf  $18}'`

Orca=`echo $all11 | awk '{printf  $20}'`

Rosco=`echo $all11 | awk '{printf $22}'`


echoIns=`kubectl get pods -n spinnaker | grep echo | tail  -n 1 | awk '{printf $2 }'`
echoSta=`kubectl get pods -n spinnaker | grep echo | tail  -n 1 | awk '{printf $3}'`

cloudIns=`kubectl get pods -n spinnaker  | grep clouddriver |  tail  -n 1 | awk '{printf $2}'`
cloudSta=`kubectl get pods -n spinnaker  | grep clouddriver |  tail  -n 1 | awk '{printf $3}'`

deckIns=`kubectl get pods -n spinnaker  | grep deck |  tail  -n 1 | awk '{printf $2}'`
deskSta=`kubectl get pods -n spinnaker  | grep deck |  tail  -n 1 | awk '{printf $3}'`

FiatIns=`kubectl get pods -n spinnaker | grep fiat | tail  -n 1 | awk '{printf $2 "\t" $3}'`
FiatSta=`kubectl get pods -n spinnaker | grep fiat | tail  -n 1 | awk '{printf $3}'`

Front50Ins=`kubectl get pods -n spinnaker  | grep front50 |  tail  -n 1 | awk '{printf $2}'`
Front50Sta=`kubectl get pods -n spinnaker  | grep front50 |  tail  -n 1 | awk '{printf $3}'`

GateIns=`kubectl get pods -n spinnaker  | grep gate |  tail  -n 1 | awk '{printf $2}'`
GateSta=`kubectl get pods -n spinnaker  | grep gate |  tail  -n 1 | awk '{printf $3}'`


IgorIns=`kubectl get pods -n spinnaker | grep igor | tail  -n 1 | awk '{printf $2}'`
IgorSta=`kubectl get pods -n spinnaker | grep igor | tail  -n 1 | awk '{printf $3}'`

KayentaIns=`kubectl get pods -n spinnaker  | grep kayenta |  tail  -n 1 | awk '{printf $2}'`
KayentaSta=`kubectl get pods -n spinnaker  | grep kayenta |  tail  -n 1 | awk '{printf $3}'`

OrcaIns=`kubectl get pods -n spinnaker  | grep orca |  tail  -n 1 | awk '{printf $2}'`
OrcaSta=`kubectl get pods -n spinnaker  | grep orca |  tail  -n 1 | awk '{printf $3}'`


RoscoIns=`kubectl get pods -n spinnaker  | grep rosco |  tail  -n 1 | awk '{printf $2}'`
RoscoSta=`kubectl get pods -n spinnaker  | grep rosco |  tail  -n 1 | awk '{printf $3}'`

echo "Kubernetes Spinnaker : " 

echo "healthStatus : Healthy"  

echo "version : $spin_version" 
printf "\n"
echo "details : "
	echo " - version : $Echo  "
	echo "   sevices : echo " 
	echo "   instances : $echoIns "
	echo "   status  : $echoSta "
printf "\n"
	echo "- version : $Clouddriver  "
	echo "  sevices : clouddriver "
	echo "  instances : $ClouddriverIns "
	echo "  status  : $ClouddriverSta "
printf "\n"
	echo "- version : $Deck   "
	echo "  sevices : Deck "
	echo "  instances : $DeckIns "
	echo "  status  : $DeckSta "
printf "\n"
	echo "- version : $Fiat  "
	echo "  sevices : Fiat "
	echo "  instances : $FiatIns "
	echo "  status  : $DeckSta "
printf "\n"
	echo "- version : $Front50  "
	echo "  sevices : Front50 "
	echo "  instances : $Front50Ins "
	echo "  status  : $Front50Sta "
printf "\n"
	echo "- version : $Gate  "
	echo "  sevices : Gate "
	echo "  instances : $GateIns "
	echo "  status  : $GateSta "
printf "\n"
	echo "- version : $Igor  "
	echo "  sevices : Igor "
	echo "  instances : $IgorIns "
	echo "  status  : $IgorSta "
printf "\n"
	echo "- version : $Kayenta  "
	echo "  sevices : Kayenta "
	echo "  instances : $KayentaIns "
	echo "  status  : $KayentaSta "
printf "\n"
	echo "- version : $Orca  "
	echo "  sevices : Orca "
	echo "  instances : $OrcaIns "
	echo "  status  : $OrcaSta "
printf "\n"
	echo "- version : $Rosco  "
	echo "  sevices : Rosco "
	echo "  instances : $RoscoIns "
	echo "  status  : $RoscoSta "
printf "\n"






