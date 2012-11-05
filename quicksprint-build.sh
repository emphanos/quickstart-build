#!/bin/bash

# ############################################## Build iso image
echo "*** Building QuickSprint ISO Image"

# ############################################## Get settings
. settings.sh

# ############################################## Build

if [ ! -f $QS_OUTPUT/$QUICKDEV_FILE.ova ] ; then
	. quickimage-build.sh dev
fi;

# Set temp dir and clean up
SAVEDIR=`pwd`
QUICKSPRINT_TEMP=$QS_OUTPUT/QuickSprint_build

. clean-iso.sh
mkdir $QUICKSPRINT_TEMP

# Put files into temp dir
cp QuickSprint/* $QUICKSPRINT_TEMP
cp $QS_OUTPUT/$QUICKDEV_FILE.ova $QUICKSPRINT_TEMP

cd $QUICKSPRINT_TEMP
wget $VBOX_HOST_WINDOWS_URL 
wget $VBOX_HOST_MAC_URL
cd $SAVEDIR

# Package as an ISO image
# FIXME see http://www.debianadmin.com/genisoimage-creates-iso-9660-cd-rom-filesystem-images.html#more-728
# For how to create custom readme's per file systems.  May not work with iamge
genisoimage -r -J -hfs -o $QS_OUTPUT/$QUICKSPRINT_FILE $QUICKSPRINT_TEMP/

