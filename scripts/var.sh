#!/bin/bash

for i in `seq 1 20`
do
./onescript.sh 0 RollingCount rollingcount.yaml
done
tar -czf var_rollingcount_20.tar.gz screenlog.0 config_files/ json_files/ net_utils/ reports/ utils/ metrics/ numbers.csv perf/
./clean.sh

for i in `seq 1 20`
do
./onescript.sh 1 RollingTopWords rollingtopwords.yaml
done
tar -czf var_rollingtopwords_20.tar.gz screenlog.0 config_files/ json_files/ net_utils/ reports/ utils/ metrics/ numbers.csv perf/
./clean.sh

for i in `seq 1 20`
do
./onescript.sh 2 SentimentAnalysis sentiment.yaml
done
tar -czf var_sentiment_20.tar.gz screenlog.0 config_files/ json_files/ net_utils/ reports/ utils/ metrics/ numbers.csv perf/
./clean.sh
