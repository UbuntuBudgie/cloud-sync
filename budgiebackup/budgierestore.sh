#!/bin/bash

# Budgie Restore Script
# Restore all budgie settings panels, themes, plank


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
  echo "!!! not enough Space in $TempDir !!!" >&2
  exit 1
fi


# Check available disk space in backup directory.

BakAvailSpace=$(df "$BakDir" | awk 'NR==2 { print $4 }')
if (( BakAvailSpace < BakReqSpace )); then
  echo "!!! not enough Space in $BakDir !!!" >&2
  exit 1
fi


# Create "budgiebackup" directory inside temporary directory.
echo
echo
echo "=== Creating temporary directory ==="
sleep $WaitTime

mkdir $TempDir/budgiebackup/


# Decompress/extract tar archive to temporary directory.
echo
echo
echo "=== Decompressing backup archive to temporary directory ==="
sleep $WaitTime

tar -xzvf $BakDir/budgiebackup.tar.gz --directory=$TempDir/budgiebackup/ 


# Add PPAs used by ubuntu budgie applets and themes. Procedure is skipped for the PPAs already enabled in system.
echo
echo
echo "=== Adding PPAs ==="
sleep $WaitTime

if [[ `lsb_release -rs` == "18.04" ]] 
	then
		if ! find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*'deb http://ppa.launchpad.net/ubuntubudgie/backports/ubuntu'
		then
  		sudo add-apt-repository -y ppa:ubuntubudgie/backports
		fi

		if ! find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*'deb http://ppa.launchpad.net/tista/adapta/ubuntu'
		then
		sudo add-apt-repository -y ppa:tista/adapta
		fi

		if ! find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*'deb http://ppa.launchpad.net/tista/plata-theme/ubuntu'
		then
		sudo add-apt-repository -y ppa:tista/plata-theme
		fi

elif [[ `lsb_release -rs` == "19.10" ]] 
	then
		if ! find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*'deb http://ppa.launchpad.net/ubuntubudgie/backports/ubuntu'
		then
  		sudo add-apt-repository -y ppa:ubuntubudgie/backports
		fi


		if ! find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*'deb http://ppa.launchpad.net/tista/plata-theme/ubuntu'
		then
		sudo add-apt-repository -y ppa:tista/plata-theme
		fi

fi

# Grab previously installed budgie software from list, and issue install command.
echo
echo
echo "=== Installing software and themes ==="
sleep $WaitTime

sudo apt-get install -y $(awk '{print $1}' $TempDir/budgiebackup/budgiebackup-applets.txt)


# Grab previoulsy installed budgie themes from list, and issue install command.

sudo apt-get install -y $(awk '{print $1}' $TempDir/budgiebackup/budgiebackup-themes.txt)


# Restore budgie applet data.
echo
echo
echo "=== Restoring budgie applets data ==="
sleep $WaitTime

rsync -vah --delete $TempDir/budgiebackup/budgie-extras/ ~/.config/budgie-extras 


# Restore plank configuration.
echo
echo
echo "=== Restoring Plank Dock configuration ==="
sleep $WaitTime

rsync -vah --delete $TempDir/budgiebackup/plank/ ~/.config/plank


# Restore budgie settings using dconf.
echo
echo
echo "=== Restoring budgie and plank settings via dconf ==="
sleep $WaitTime

dconf load /com/solus-project/ < $TempDir/budgiebackup/budgie-dconf-dump

# Restore plank settings using dconf.
dconf load /net/launchpad/plank/docks/ < $TempDir/budgiebackup/plank-dconf-dump


# Delete temporary directory.
echo
echo
echo "=== Deleting temporary direcory ==="
sleep $WaitTime

rm -R $TempDir/budgiebackup/


# Prompt for log off
#
echo
echo
echo "=== Budgie restore completed ==="
echo "=== Log off to apply changes ==="
sleep $WaitTime

gnome-session-quit

