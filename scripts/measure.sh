#!/bin/bash

for i in `seq 5 10`
do 
./onescript_new.sh 0 &
sleep 100
for j in `seq 1 5`
do
java -cp /home/ubuntu/bilal/TDigestService/target/TDigestService-1.0-SNAPSHOT-jar-with-dependencies.jar com.tdigestclient.Main 127.0.0.1 11111 0.9 >> 90th_Lat$i.log
java -cp /home/ubuntu/bilal/TDigestService/target/TDigestService-1.0-SNAPSHOT-jar-with-dependencies.jar com.tdigestclient.Main 127.0.0.1 11111 0.99 >> 99th_Lat$i.log
sleep 10
done
sleep 100
done
