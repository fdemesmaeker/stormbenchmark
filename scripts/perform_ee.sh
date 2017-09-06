#!/bin/bash

# Get rankings for all the metrics
for i in `seq 50 10 90` 
do
echo "For $i th percentile latency"
python ee.py lat_$i numbers.csv conf_rollingcount_hc.yaml lat_$i.html
done
echo "For throughput"
python ee.py throughput numbers.csv conf_rollingcount_hc.yaml throughput.html
