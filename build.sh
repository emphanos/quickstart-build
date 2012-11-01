#!/bin/bash

## NOTE: You do not need to do this if you want to *use* Quickstart.  
#
#  You can save yourself some time with the instructions here:
#
#  http://<url>


## This script will build a Quickstart Development Environment
#
# The Quickstart 3.0 build environment is Ubuntu 12.04.
# If you're not using Ubuntu 12.04, this may not work.
#
# Documentation: http://<url>


# ############################################## Get settings
. build-settings.sh

# ############################################## Build everything

# Check for QuickBox in list of available vagrant boxes.  Rebuild if not there
if [ -z `vagrant box list | grep QuickBox` ]; then
  echo "*** Rebuilding QuickBox"
  ( cd QuickBox; bash rebuild.sh )  #runs commands in it's own shell
else
  echo "*** Using existing QuickBox.  
 * vagrant box remove QuickBox to force re-update
 * vagrant box remove precise64 to force redownload"
fi

# Build everything else
. build-box.sh Base
. build-box.sh Test
. build-box.sh Prod
. build-box.sh Dev





