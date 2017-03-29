#!/bin/bash
# Requires 3 arguments
# 1: Directory to write backup repositories to
# 2: sh file containing a keyvalue array with reponame as key and folder to backup as value
# 3: Passowrd to encrypt with
BACKUPDIR=$1

source $2

export BORG_PASSPHRASE=$3

if [ ! -d "$BACKUPDIR" ]; then
	mkdir $BACKUPDIR
	/usr/local/bin/borg --version > "$BACKUPDIR/borg_version"
fi
for i in "${!folders[@]}"
do
	if [ ! -d "$BACKUPDIR/$i" ]; then
		/usr/local/bin/borg init "$BACKUPDIR/$i" -e repokey
	fi
	/usr/local/bin/borg create "$BACKUPDIR/$i::"`date +%Y-%m-%d-%H-%M-%S` \
		${folders[$i]}
	/usr/local/bin/borg prune  "$BACKUPDIR/$i" --keep-hourly=4 --keep-daily=7 --keep-weekly=4 --keep-monthly=6
done

