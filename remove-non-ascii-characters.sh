#/bin/bash

DIR=${1-"."}
TMP="tmp.java"

IFS=$'\n'; set -f
for f in $(find $DIR -name '*.java'); do
        tr -cd '\11\12\15\40-\176' < $f > $TMP
        rm $f
        mv $TMP $f
done
unset IFS; set +f
