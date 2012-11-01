#!/bin/bash

# ############################################## Clean iso image
# clean-iso.sh

# ############################################## Get settings
. build-settings.sh

# clean up
rm -rf $QS_OUTPUT/QuickSprint_build
rm -f $QS_OUTPUT/$QUICKSPRINT_FILE.iso 


