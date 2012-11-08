#!/bin/bash

echo "*** Cleaning QuickSprint ISO Image"

# ############################################## Get settings
. settings.sh

# clean up
rm -rf $QUICKSPRINT_TEMP
rm -f $QS_OUTPUT/$QUICKSPRINT_FILE 


