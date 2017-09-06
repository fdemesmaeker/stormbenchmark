#!/bin/bash
jps | grep "TServer" | awk '{print $1}' | xargs -I {} kill -9 {}
screen -dmS topology0 bash -c './onescript.sh 0 11111'

screen -dmS topology1 bash -c './temp.sh 1 11112'
jps | grep "TServer" | awk '{print $1}' | xargs -I {} kill -9 {}
