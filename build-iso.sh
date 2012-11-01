#!/bin/bash

# ############################################## Build iso image
# build-iso.sh

# ############################################## Get settings
. build-settings.sh

# ############################################## Build

# Set temp dir and clean up
SAVEDIR=`pwd`
QUICKSPRINT_TEMP=$QS_OUTPUT/QuickSprint_build
rm -rf $QUICKSPRINT_TEMP
mkdir $QUICKSPRINT_TEMP

# Put files into temp dir
cp QuickSprint/* $QUICKSPRINT_TEMP
cp $QS_OUTPUT/$QUICKDEV_FILE.ova $TEMPDIR

cd $QUICKSPRINT_TEMP
wget $VBOX_HOST_WINDOWS_URL 
wget $VBOX_HOST_MAC_URL
cd $SAVEDIR

# Package as an ISO image
genisoimage -o $QS_OUTPUT/$QUICKSPRINT_FILE.iso $QUICKSPRINT_TEMP/

# Clean up
rm -rf $QUICKSPRINT_TEMP


