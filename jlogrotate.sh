#!/bin/bash
# Rotate Java Server log files (JBoss, Tomcat, ...)
#
# Copyright (c) 2012 Malte S. Stretz, Silpion IT-Solutions GmbH

set -e

logname=logs/server.log
zcmd=gzip
zext=gz
force=

while getopts 'jf' OPTNAME; do
    shift
    case "$OPNAME" in
       j)
           zcmd=bzip2
           zext=bz2
       ;;
       f)
           force=-f
       ;;
    esac
done

if [ "$1" ]; then
    logname=$1
fi

for logfile in $logname.????-??-??; do
    test -r "$logfile"
    $zcmd -9 $force "$logfile"
done
