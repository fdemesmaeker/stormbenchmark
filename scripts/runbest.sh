#!/bin/bash

function utilizations {
while IFS='' read -r line || [[ -n "$line" ]]; do
    #echo "Text read from file: $line"
j=1
ssh -o ServerAliveInterval=60 $line 'mpstat -P ALL 50 4' > utils/server$j"_util$1.log" & 
ssh -o ServerAliveInterval=60 $line 'ifstat 10 22' > net_utils/server$j"_net$1.log" &
let j=j+1
done < hosts
}
function redis_getmetrics {
$REDIS_HOME/./redis-cli keys "*" | sort -n | xargs -I {} $REDIS_HOME/./redis-cli get {} > metrics/metrics$1.log
}

function redis_cleanup {
$REDIS_HOME/./redis-cli FLUSHALL
}

function getmetrics {
while IFS='' read -r line || [[ -n "$line" ]]; do
ssh -n -o ServerAliveInterval=60 $line "test -s $STORM_HOME/logs/metrics.log"
if [ $? -eq 0 ]; then
    mkdir -p logs
    scp -r $line:$STORM_HOME/logs/logs/metrics.log* logs/
    scp -r $line:$STORM_HOME/logs/metrics.log logs/
    ssh -n -o ServerAliveInterval=60 $line "rm -rf $STORM_HOME/logs"
    #mkdir -p logs/logs/
    #cp logs/metrics.log logs/logs/metrics.log
    ls -r logs/metrics* | xargs -I {} cat {} >> metrics/metrics$1.log
    rm -rf logs/
fi
done < hosts
}
function cleanup {
while IFS='' read -r line || [[ -n "$line" ]]; do
ssh -n -o ServerAliveInterval=60 $line "rm -rf $STORM_HOME/logs/metrics.log"
done < hosts
}
function getcounters {
sleep 40
while IFS='' read -r line || [[ -n "$line" ]]; do
scp -r test.sh $line:~/bilal/
ssh -f -n -o ServerAliveInterval=60 $line "bash ~/bilal/test.sh"
#ssh -n -o ServerAliveInterval=60 $line "PID=$(jps | grep 'worker' | awk '{print $1}'); perf stat -p $PID -a -I 300000 -o perf/test$1.log & PERF_PID=$!; sleep 310; kill -9 $PERF_PID" &
done < hosts
}

function copycounters {
while IFS='' read -r line || [[ -n "$line" ]]; do
scp -r $line:~/perf/test.log perf/test$1_$line.log
done < hosts
}

function queuestats {
while IFS='' read -r line || [[ -n "$line" ]]; do
# This should be ssh command
ssh -o ServerAliveInterval=60 ubuntu@sys-n03.info.ucl.ac.be "cd $STORM_HOME/logs/workers-artifacts; find $(ls -tr | tail -n1) -name 'worker.log.metrics' | xargs -I {} cat {} | grep -o 'population=[0-9]*'"
done < hosts
}
#python wspAlgorithm.py single 21
#STORM_HOME=~/bilal/storm
#STORM_HOME=/usr/local/ansible-test/storm/apache-storm-0.9.3
#STORM_HOME=~/ansible-test/storm/apache-storm-0.9.5
STORM_HOME=~/ansible-test/storm/apache-storm-1.0.1
REDIS_HOME=~/bilal/redis-3.2.0/src
TOPOLOGY=RollingCount
CONF=rollingcount.yaml

#Kil any older running topologies
$STORM_HOME/bin/storm kill $TOPOLOGY -w 1
sleep 5

mkdir -p config_files
i=$1
#nfiles=$(ls config_files/ | wc -l)
echo nfiles
mkdir -p utils
mkdir -p net_utils
mkdir -p perf
cleanup
#python randomize.py
cp config_files/run$i.yaml ~/.storm/$CONF
#cat ~/.storm/sol.yaml
../bin/stormbench -storm $STORM_HOME/bin/storm -jar ../target/storm-benchmark-0.1.0-jar-with-dependencies.jar -conf ~/.storm/$CONF  storm.benchmark.tools.Runner storm.benchmark.benchmarks.$TOPOLOGY &
utilizations $i
kill -9 $(jps | grep "TServer" | awk '{print $1}')
nohup java -cp ~/bilal/TDigestService/target/TDigestService-1.0-SNAPSHOT-jar-with-dependencies.jar com.tdigestserver.TServer 11111 &
sleep 10
