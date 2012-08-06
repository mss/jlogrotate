#!/bin/bash
# Rotate and purge old Java Server log files (JBoss, Tomcat, ...).
# This script is probably called by cron.
#
# Copyright (c) 2012 Malte S. Stretz, Silpion IT-Solutions GmbH <http://www.silpion.de>

set -e
shopt -s nullglob

logname=logs/server.log
zcmd=gzip
zext=gz
keep=
force=
verbose=

while getopts 'jfk:v' OPTNAME; do
    case "$OPTNAME" in
       j)
           zcmd=bzip2
           zext=bz2
       ;;
       f)
           force=-f
       ;;
       v)
           verbose=-v
       ;;
       k)
           keep=$OPTARG
       ;;
    esac
done
shift $((OPTIND-1))

if [ "$1" ]; then
    logname=$1
fi
logname="$logname.????-??-??"

if [ "$verbose" ]; then
    echo "compressing $logname..."
fi
for logfile in $logname; do
    $zcmd -9 $force $verbose "$logfile"
done

if [ "$keep" ]; then
    if [ "$verbose" ]; then
        echo "purging obsolete $logname.$zext..."
    fi
    ls -1 $logname.$zext | sort -r | tail -n +$keep | xargs -d '\n' -r rm $force $verbose
fi

