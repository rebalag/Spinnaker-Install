#!/bin/bash

cd deck
./gradlew build > build.log

cd ..
cd clouddriver
./gradlew build > build.log
./gradlew clouddriver-web:installDist -x test > install.log

cd ..
cd gate
./gradlew build > build.log
./gradlew gate-web:installDist -x test > install.log


cd ..
cd fiat
./gradlew build > build.log
./gradlew fiat-web:installDist -x test > install.log

cd ..
cd orca
./gradlew build > build.log
./gradlew orca-web:installDist -x test > install.log

cd ..
cd rosco
./gradlew build > build.log
./gradlew rosco-web:installDist -x test > install.log

cd ..
cd igor
./gradlew build > build.log
./gradlew igor-web:installDist -x test > install.log

cd ..
cd kayenta
./gradlew build > build.log
./gradlew kayenta-web:installDist -x test > install.log

cd ..
cd halyard
./gradlew build > build.log
./gradlew halyard-web:installDist -x test > install.log

cd ..
cd front50
./gradlew build > build.log
./gradlew front50-web:installDist -x test > install.log

cd ..
cd echo
./gradlew build > build.log
./gradlew echo-web:installDist -x test > install.log

cd ..
cd spin
./gradlew build > build.log
cd ..
cd spinnaker-dependencies
./gradlew build > build.log
cd ..
#cd spinnaker-monitoring
#./gradlew build
#./gradlew spinnaker-monitoring-web:installDist -x test
