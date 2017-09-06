#!/bin/bash

for i in `seq 0 29`
do
sed -i 's/A_Tale_of_Two_City.txt/random_data.txt/g' config_files/test$i.yaml
./onescript.sh $i
done
