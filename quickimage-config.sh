#!/bin/bash

echo "*** Configuring $1"


# ############################################## Get settings
. settings.sh

# To debug, use a "shared folder" mounted, so we don't have to push changes through git.
QS_CONFIG_DIR=/var/quickstart/quickstart-configure
if [ ! -z "$QS_DEBUG" ]; then
  QS_CONFIG_DIR=/var/quickstart/quickstart-configure-live
  echo " *** DEBUG MODE ON.  Using $QS_CONFIG_DIR"
fi

# Configuration commands - passed through ssh
QS_GO_QUICKTEST="sudo su $QS_USER -c \"cd $QS_CONFIG_DIR; . config.sh test\""
QS_GO_QUICKPROD="sudo su $QS_USER -c \"cd $QS_CONFIG_DIR; . config.sh prod\""
QS_GO_QUICKDEV="sudo su $QS_USER -c \"cd $QS_CONFIG_DIR; . config.sh dev\""


# ############################################## Build

# Get UUID
echo "** Checking for QuickBase snapshot ..."
qs_get_base_uuid

# If no UUID, then rebuild quickbase
echo "UUID ================$QUICKBASE_UUID======================"
if [ -z $QUICKBASE_UUID ]; then
	. quickbase-build.sh
fi

# QS_GO defined here, used below!
if [ "$1" == 'test' ]; then
  QS_GO=$QS_GO_QUICKTEST
elif [ "$1" == 'prod' ]; then 
  QS_GO=$QS_GO_QUICKPROD
elif [ "$1" == 'dev' ]; then 
  QS_GO=$QS_GO_QUICKDEV
else
  echo "Usage: $0 [ test | prod | dev ]"
  exit
fi


# Restore QuickBase snapshot
echo "** Restoring snapshot of QuickBase working copy ..."
vagrant halt
sleep 20
vboxmanage snapshot $QUICKBASE_UUID restorecurrent
if [ $? -gt 0 ]; then QS_ERROR=" !!! Vboxmanage error"; exit; fi


# Start vagrant (no need to rerun provision scripts)
echo "** Starting QuickBase working copy ..."
vagrant up --no-provision
if [ $? -gt 0 ]; then QS_ERROR="Vagrant up error"; exit; fi


# Configure the image
echo "** Configuring QuickBase working copy as $1 ..."
vagrant ssh -c "$QS_GO $QS_DEBUG"
if [ $? -gt 0 ]; then QS_ERROR="Vagrant ssh error"; exit; fi


# Run manual configuration
if [ "$1" == 'dev' ]; then
	# reboot in graphics mode
	vagrant halt
	sleep 20
	vagrant up 
	echo "** Starting manual configuration of QuickBase working copy as $1 ..."
	echo "=======================
***
***    1) Click the circle and select Cinnamon
***    2) Login as $QS_USER  (password $QS_USER)
***    3) Start terminal (Ctrl-Alt-T)
***    4) $ cd /var/quickstart/quickstart-configure
***    5) $ bash manualconfig.sh
***    6) Follow the instructions
***
========================="
	read
	
	vagrant ssh -c "$QS_GO $QS_DEBUG"
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant ssh error"; exit; fi
fi


# Prep for export if appropriate
if [ -z "$QS_DEBUG" ]; then
  echo " *** DEBUG MODE OFF.  Prepping for export"
  vagrant ssh -c "sudo su $QS_USER -c \". $QS_CONFIG_DIR/exportprep.sh\""
fi

# Done
vagrant halt

echo "**   ...  Done"

. finish.sh quickimage-config.sh

