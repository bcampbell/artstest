#!/bin/bash

# script to run scraper on a set of test articles and check results
# against expected data

set -e
# the command to nvoke to scrape
scrape=/home/ben/mygo/src/arts/scrapetool/scrapetool

# command to compare scrape output against .expected files
compare=./compare

if [ -z "$1" ]
then
    # default - scan data dir
    inputs=$(find data -iname "*.expected")
elif [ -d "$1" ]; then
    # param is an alternative directory to scan
    inputs=$(find "$1" -iname "*.expected")
else
    # param is an individual .expected file to run
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
