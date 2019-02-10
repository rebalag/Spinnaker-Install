# Spinnaker-Install
Build system requirement: (Base OS : Ubuntu 14,16 and CentOS 7)
Prereq:
1. java 1.8
2. git client 1.8.3.1 or above
3. gradle 4.7 or above
4. Docker 18.09.x or above
5. Alpine images:
	For Dockerfile.slim:
	- clouddriver : openjdk:8-jdk-alpine
	- deck : debian:stable-slim
	- echo : openjdk:8-jre-alpine
	- fiat : openjdk:8-jre-alpine
	- gate : openjdk:8-jre-alpine
	- rosco : openjdk:8-jre-alpine
	- halyard : openjdk:8-jre-alpine
	- kayenta : openjdk:8-jre-alpine
	- igor : openjdk:8-jre-alpine
	- front50 : openjdk:8-jre-alpine
	- orca : openjdk:8-jre-alpine
    - spinnaker-monitoring : python:2.7.14-alpine3.7
6. For Redis and Minio:
	- Minio image : minio/minio:latest (version 1.6.3 or later)
    - Redis image : bitnami/redis (version 3.8.0, tested with 2.2 and later)

Deployment cluster:
	- Openshift 3.9.x or later (for manifest based deployment from Spinnaker)
	- Artifactory 5.x 





External URLs referred in gradle build process:
- https://plugins.gradle.org/m2/
- http://spinnaker.bintray.com/gradle  
[http://spinnaker.bintray.com/gradle/com/netflix/spinnaker/spinnaker-gradle-project/1.12.1/]
- https://repo.spring.io/libs-snapshot/
- https://repo.jfrog.org:443
- https://jcenter.bintray.com
-------
- https://registry-1.docker.io/v2/ (while building docker image)
- https://releases.hashicorp.com/packer/1.3.1/packer_1.3.1_linux_amd64.zip (rosco)
- https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get (rosco)
- https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip (clouddriver)
- https://storage.googleapis.com/kubernetes-release/release/stable.txt (clouddriver)
- https://storage.googleapis.com/kubernetes-release/release/$(cat stable.txt)/bin/linux/amd64/kubectl (clouddriver)
- https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws (clouddriver)


Build Strategy:
- git clone spinnaker 1.12.1/master-unvalidate repo (run download script as root)
  [11 spinnaker microservices]
- change owner of all folders of cloned repo to user in VM. 
- go in each folder of microservice and run ./gradlew build && ./gradlew *-web:installDist (buildspinnaker.sh)
- Build all spinnaker service containers and push to docker repo
- If artifactory is selfsigned then require certificate to be embedded in clouddriver image :
  i. openssl x509 -in <(openssl s_client -connect <artifactory address>:<port> -prexit 2>/dev/null) > cert.pem
  ii. keytool -importcert -file /home/spinnaker/cert.pem -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -noprompt -storepass changeit 
			or 
	echo yes | keytool -importcert -alias ciscorootcert -file /home/spinnaker/ciscoroot.crt -trustcacerts -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts  -storepass changeit

Build implementation:
- create new folder (say spinnaker-master)
- copy following script files in above folder:
	i.	download-spinnaker-master.sh
	ii.	build-spinnaker.sh
	iii.build-container.sh
- go to above folder
- run download-spinnaker-master.sh
- after completion of download-spinnaker-master.sh script, run build-spinnaker.sh
- go to clouddriver folder
- remove following lines from (clouddriver) Dockerfile.slim file:
		RUN apk --no-cache add --update bash wget unzip 'python2>2.7.9' && \
		  wget -nv https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
		  unzip -qq google-cloud-sdk.zip -d /opt && \
		  rm google-cloud-sdk.zip && \
		  CLOUDSDK_PYTHON="python2.7" /opt/google-cloud-sdk/install.sh --usage-reporting=false --bash-completion=false --additional-components app-engine-java && \
		  rm -rf ~/.config/gcloud

		 RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws && \
		  chmod +x ./heptio-authenticator-aws && \
		  mv ./heptio-authenticator-aws /usr/local/bin/heptio-authenticator-aws

		RUN apk -v --update add py-pip && \
		  pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
		  apk -v --purge del py-pip && \
		  rm /var/cache/apk/*

		ENV PATH "$PATH:/usr/local/bin/heptio-authenticator-aws"

		ENV PATH=$PATH:/opt/google-cloud-sdk/bin/
		

Deployment Strategy:
- Deployment of Minio with PVC
- Deployent of Redis with PVC (optional)
- Create customized BOM file as configmap
- Create kubeconfig file as secret
- Create service-setting files configmap with artifactID
- Create .hal/config configmap containing halyard configuration:
  For K8 v1:
  i. docker registry account
  ii. kubernetes account
  iii. S3
  iV. ldap (optional)
  For K8 v2:
  i. kubernetes account
  ii. S3
  iii. ldap (optional)
  
- Apply all the configmaps and secrets to OC.
- Make sure OC get anyuid for namespace to be used for spinnaker deployment.
- Deploy halyard service with appropriate mounting of configmaps and secrets

- blue/green deployment of 1 microservice using spinnaker pipeline
