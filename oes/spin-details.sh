#!/bin/bash

all11=`hal version bom | grep -m11 version:`

printf "\n"

Spin=`echo $all11 | awk '{printf $2}'`

Echo=`echo $all11 | awk '{printf $4}'`

Clouddriver=`echo $all11 | awk '{printf $6}'`

Deck=`echo $all11 | awk '{printf $8}'`

Fiat=`echo $all11 | awk '{printf $10}'`

Front50=`echo $all11 | awk '{printf $12}'`

Gate=`echo $all11 | awk '{printf $14}'`

Igor=`echo $all11 | awk '{printf $16}'`

Kayenta=`echo $all11 | awk '{printf $18}'`

Orca=`echo $all11 | awk '{printf $20}'`

Rosco=`echo $all11 | awk '{printf $22}'`


check_port() {
out="$1"
if [ "$(netstat -el --numeric-ports | grep $1)" ]; then
out="$out Ok"
else
out="$out Failed"
fi
printf "$out"
}

check_upstart() {
out="$1"
if [ "$(status $1 | grep running)" ]; then
out="$out Running"
else
out="$out Failed"
fi
printf "$out"
}

echo "Spinnaker Version: " $Spin

row() {
printf "| %-5s | %-15s | %15s | %25s | %10s | %10s |\n" "$1" $2 $3 $4 $5 $6
}

row "Sr No" "Service_Name" "Service_Status" "Version" "Service_Port" "Port_Status"
row 1. 'spinnaker-(deck)' "Running" `echo $Deck` `check_port 9000`
row 2. "redis" "Running" "-" `check_port 6379`
row 3. `check_upstart clouddriver` `echo $Clouddriver` `check_port 7002`
row 4. `check_upstart "echo"` `echo $Echo` `check_port 8089`
row 5. `check_upstart front50` `echo $Front50` `check_port 8080`
row 6. `check_upstart gate` `echo $Gate` `check_port 8084`
row 7. `check_upstart igor` `echo $Igor` `check_port 8088`
row 8. `check_upstart orca` `echo $Orca` `check_port 8083`
row 9. `check_upstart rosco` `echo $Rosco` `check_port 8087`
row 10. `check_upstart kayenta` `echo $Kayenta` `check_port 8090`
row 11. 'Fiat' "_" `echo $Fiat` `check_port 7003`
