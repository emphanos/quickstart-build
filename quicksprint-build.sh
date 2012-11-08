#!/bin/bash

# ############################################## Build iso image
echo "*** Building QuickSprint ISO Image"

# ############################################## Get settings
. settings.sh

# ############################################## Build

if [ ! -f $QS_OUTPUT/$QUICKDEV_FILEBASE.ova ] ; then
	. quickimage-build.sh dev
fi;

# Set temp dir and clean up
QUICKSPRINT_TEMP=QuickSprint_build
. quicksprint-clean.sh
mkdir $QUICKSPRINT_TEMP

# Put files into temp dir
cp QuickSprint/* $QUICKSPRINT_TEMP
cp $QS_OUTPUT/$QUICKDEV_FILEBASE.ova $QUICKSPRINT_TEMP

# Download Virtualbox Installers
SAVEDIR=`pwd`
cd $QUICKSPRINT_TEMP
wget $VBOX_HOST_WINDOWS_URL 
wget $VBOX_HOST_MAC_URL
cd $SAVEDIR

# Package as an ISO image
# FIXME see http://www.debianadmin.com/genisoimage-creates-iso-9660-cd-rom-filesystem-images.html#more-728
# For how to create custom readme's per file systems.  May not work with iamge
genisoimage -r -J -hfs -o $QS_OUTPUT/$QUICKSPRINT_FILE $QUICKSPRINT_TEMP/

