#!/bin/bash
# Rotate Java Server log files (JBoss, Tomcat, ...)
#
# Copyright (c) 2012 Malte S. Stretz, Silpion IT-Solutions GmbH

set -e
shopt -s nullglob

logname=logs/server.log
zcmd=gzip
zext=gz
force=
verbose=

while getopts 'jfv' OPTNAME; do
    case "$OPTNAME" in
       j)
           zcmd=bzip2
           zext=bz2
       ;;
       f)
           force=f
       ;;
       v)
           verbose=v
       ;;
    esac
done
shift $((OPTIND-1))

if [ "$1" ]; then
    logname=$1
fi

for logfile in $logname.????-??-??; do
    $zcmd -9$force$verbose "$logfile"
done
