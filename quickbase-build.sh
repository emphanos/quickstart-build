#!/bin/bash

# ############################################## Build Quickbase
# QuickBase is the base image all other images are built from.

# ############################################## Get settings
. settings.sh


# ############################################## Build QuickBox if necessary
# Check for QuickBox in list of available vagrant boxes.  Rebuild if not there
if [ -z `vagrant box list | grep QuickBox` ]; then
  echo "*** Rebuilding QuickBox"
  ( cd QuickBox; bash rebuild.sh )  # ( ) runs commands in it's own shell
else
  echo "*** Using existing QuickBox.  
 * 'vagrant box remove precise64' to force redownload of base image
 * 'vagrant box remove QuickBox' to force re-update
"
fi


# ############################################## Build
. quickbase-clean.sh
. quickbase-config.sh

