#!/bin/bash


set -e
scrape=/home/ben/mygo/src/arts/scrapetool/scrapetool
compare=./compare

if [ -z "$1" ]
then
    inputs=$(find data -iname "*.expected")
else
    inputs="$1"
fi

for expected in $inputs; do
    htmlfile=$(echo $expected | sed 's/\.expected/\.html/')
    tmpfile=$(mktemp)
    #echo >&2 $htmlfile
    ${scrape} "file://$(pwd)/$htmlfile" >$tmpfile
    ${compare} $tmpfile $expected
    rm $tmpfile
done
