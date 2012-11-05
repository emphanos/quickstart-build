#!/bin/bash

echo "*** Cleaning QuickSprint ISO Image"

# ############################################## Get settings
. settings.sh

# clean up
rm -rf $QS_OUTPUT/QuickSprint_build
rm -f $QS_OUTPUT/$QUICKSPRINT_FILE 


