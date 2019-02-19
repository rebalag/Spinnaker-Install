#!/bin/bash

spin_version=`hal version bom | grep -m1 version:`

echo "{Kubernetes Spinnaker":{"Health Status":"Healthy",$spin_version}}
