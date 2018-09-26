#!/bin/bash
# Requires 2 arguments
# 1: Directory to write backup repositories to
# 2: sh file containing a keyvalue array with reponame as key and folder to backup as value
BACKUPDIR=$1

source $2

CURRDIR=$PWD
for i in "${!folders[@]}"
do
	cd "$BACKUPDIR/$i"
	zip -r -q "/tmp/$i.zip" ./
	/usr/local/bin/b2 upload-file --noProgress "dedi-backups" "/tmp/$i.zip" $i.zip
done

