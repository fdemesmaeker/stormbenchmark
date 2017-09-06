#!/bin/bash

for i in `seq 1 4`
do
python rule_based.py conf_rollingcount_hc.yaml rollingcount.yaml lat_90,throughput=150000 relations.yaml lat$i.yaml tp.yaml
tar -czf rule_based_rollingcount_t0.4_tp100k_6conf_$i\_1.tar.gz config_files/ json_files/ net_utils/ reports/ utils/ metrics/ numbers.csv perf/ screenlog.0
./clean.sh

python rule_based.py conf_rollingcount_hc.yaml rollingcount.yaml lat_90,throughput=150000 relations.yaml lat$i.yaml tp.yaml
tar -czf rule_based_rollingcount_t0.4_tp100k_6conf_$i\_2.tar.gz config_files/ json_files/ net_utils/ reports/ utils/ metrics/ numbers.csv perf/ screenlog.0
./clean.sh

python rule_based.py conf_rollingcount_hc.yaml rollingcount.yaml lat_90,throughput=150000 relations.yaml lat$i.yaml tp.yaml
tar -czf rule_based_rollingcount_t0.4_tp100k_6conf_$i\_3.tar.gz config_files/ json_files/ net_utils/ reports/ utils/ metrics/ numbers.csv perf/ screenlog.0
./clean.sh

done
