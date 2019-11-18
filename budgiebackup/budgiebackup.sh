#!/bin/bash

# Budgie Backup Script
# Backup all budgie settings panels, themes, plank


####
#### VARIABLES
####


# TempDir. Parent folder where files are stored here until script ends.
TempDir=/tmp

# TempReqSpace. Space required in TempDir directory. In Bytes.
# Default: 10000000 bytes (10 Megabytes).
TempReqSpace=10000000



# BakDir. Final Backup file will be stored here.
# Default: /tmp
BakDir=~/

# BakReqSpace. Space required in BakDir directory. In Bytes.
# Default: 10000000 bytes (10 Megabytes).
BakReqSpace=10000000


# Wait Time between commands
# Default: 2 Seconds
WaitTime=2




####
#### SCRIPT - DO NOT EDIT BELOW THIS POINT
####


# Check available disk space in temporary directory.
echo 
echo
echo "=== Checking available disk space. quit if check fails ===" 
sleep $WaitTime

TempAvailSpace=$(df "$TempDir" | awk 'NR==2 { print $4 }')
if (( TempAvailSpace < TempReqSpace )); then
  echo "not enough Space in $TempDir" >&2
  exit 1
fi


# Check available disk space in backup directory.

BakAvailSpace=$(df "$BakDir" | awk 'NR==2 { print $4 }')
if (( BakAvailSpace < BakReqSpace )); then
  echo "not enough Space in $BakDir" >&2
  exit 1
fi


# Create temporary directory.
echo
echo
echo "=== Creating temporary directory ==="
sleep $WaitTime

mkdir $TempDir/budgiebackup


# Query installed budgie applets, filter by "budgie applets" output list to file.
echo
echo
echo "=== Saving installed budgie applets to list ==="
sleep $WaitTime

dpkg --get-selections \budgie*\*applet | awk '{print $1}' > $TempDir/budgiebackup/budgiebackup-applets.txt



# Query installed budgie themes, filter by "theme name", and output list to file.
echo
echo
echo "=== Saving installed budgie themes to list ==="
sleep $WaitTime

dpkg --get-selections ubuntu-budgie-themes | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections ant-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections arc-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections evopop-gtk-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections adapta-gtk-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections materia-gtk-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections vimix-gtk-themes | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections plata-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt
dpkg --get-selections pocillo-icon-theme | awk '{print $1}' >> $TempDir/budgiebackup/budgiebackup-themes.txt


# Backup current user's budgie applet data.
echo
echo
echo "=== Backing up budgie applets data ==="
sleep $WaitTime

rsync -vah ~/.config/budgie-extras $TempDir/budgiebackup/


# Backup current user's plank launchers configuration.
echo
echo
echo "=== Backing up plank configuration ==="
sleep $WaitTime

rsync -vah ~/.config/plank $TempDir/budgiebackup/


# Backup budgie settings by dumping dconf to file.
echo
echo
echo "=== Backing up budgie and plank settings via dconf ==="
sleep $WaitTime

dconf dump /com/solus-project/ > $TempDir/budgiebackup/budgie-dconf-dump


# Backup plank docks settings by dumping dconf to file.

dconf dump /net/launchpad/plank/docks/ > $TempDir/budgiebackup/plank-dconf-dump



# Compress all files in temporary folder, and save archive in backup location.
echo
echo
echo "=== Compressing backup archive to temporary directory ==="
sleep $WaitTime

tar -czvf $BakDir/budgiebackup.tar.gz -C $TempDir/budgiebackup .


# Delete temporary folder.
echo
echo
echo "=== Deleting temporary direcory ==="
sleep $WaitTime

rm -R $TempDir/budgiebackup/

# Backup completed.
echo
echo
echo "=== Budgie backup completed ==="

