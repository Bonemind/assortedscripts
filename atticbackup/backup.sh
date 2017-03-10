#!/bin/bash
# Requires 3 arguments
# 1: Directory to write backup repositories to
# 2: sh file containing a keyvalue array with reponame as key and folder to backup as value
# 3: Passowrd to encrypt with
BACKUPDIR=$1

source $2

export ATTIC_PASSPHRASE=$3

if [ ! -d "$BACKUPDIR" ]; then
	mkdir $BACKUPDIR
fi
for i in "${!folders[@]}"
do
	echo "${folders[$i]}"
	if [ ! -d "$BACKUPDIR/$i" ]; then
		/usr/local/bin/attic init "$BACKUPDIR/$i" -e passphrase
	fi
	/usr/local/bin/attic create --stats "$BACKUPDIR/$i::"`date +%Y-%m-%d-%H-%M-%S` \
		${folders[$i]}
	/usr/local/bin/attic prune -v "$BACKUPDIR/$i" --keep-hourly=4 --keep-daily=7 --keep-weekly=4 --keep-monthly=6
done

