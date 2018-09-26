# BorgBackup


Script that takes an associative array of names an paths, loops through them and backs up every path
to a repository with the key as it's name.

Setup a cronjob for `./backup.sh`

Usage:

```
./backup.sh <Backup dir> <File containing associative array> <Passphrase>

Backupdir: The directory all repositories will be stored in
Assoc-array file: File that gets sourced to determine what to backup where. See folders.sh
Passphrase: Passphrase used to encrypt the backups
```

In addition, there's a b2 upload script:
```
./b2backup.sh <Backup dir> <File containing associative array>

Backupdir: The directory all repositories will be stored in
Assoc-array file: File that gets sourced to determine what to backup where. See folders.sh
```
