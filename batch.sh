#!/bin/bash

# script to run scraper on a set of test articles and check results
# against expected data

set -e
# the command to invoke to scrape
scrape="go run /home/ben/mygo/src/github.com/bcampbell/arts/scrapetool/main.go"

# command to compare scrape output against .expected files
compare=./compare
compare_flags=
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

goodcnt=0
badcnt=0
errcnt=0
for expected in $inputs; do
    htmlfile=$(echo $expected | sed 's/\.expected/\.html/')
    tmpfile=$(mktemp)
    #echo >&2 $htmlfile
    ${scrape} "file://$(pwd)/$htmlfile" >$tmpfile
    set +e
    errs=$(${compare} ${compare_flags} $tmpfile $expected)
    result=$?
    if [ $result -eq 0 ]; then
        echo "GOOD: ${expected}"
        let goodcnt=goodcnt+1
    elif [ $result -eq 1 ]; then
        echo "BAD: ${expected}"
        echo "$errs"
        let badcnt=badcnt+1
    else
        echo "ERROR: ${expected}"
        echo "$errs"
        let errcnt=errcnt+1
    fi
    set -e
    rm $tmpfile
done

echo "${goodcnt} good, ${badcnt} bad, ${errcnt} errors"
