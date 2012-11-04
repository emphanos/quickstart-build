#!/bin/bash

echo "*** Cleaning $1"

# ############################################## Get settings
. settings.sh


# ############################################## Functions

## Destroy a vm in Virtualbox.  Suppress "does not exist" errors.  
qs_vbox_clean() {
	echo "** Removing output virtualbox image: $1  ..."
	vboxmanage controlvm "$1" poweroff 2> /dev/null; sleep 5
	vboxmanage unregistervm "$1" --delete 2> /dev/null
	echo "**   ...  Done"
}

## Clean output files
qs_output_clean() {
	echo "** Removing output files:" "$QS_OUTPUT"/"$1.box" "$QS_OUTPUT"/"$1.ova"
	rm -f "$QS_OUTPUT"/"$1.box"
	rm -f "$QS_OUTPUT"/"$1.ova"
	echo "**   ...  Done"
}


# ############################################## Clean Build is cleaning vagrant

if [ "$1" == "test" ]; then
	qs_output_clean "$QUICKTEST_FILEBASE"
	qs_vbox_clean "$QUICKTEST_VBOX"
elif [ "$1" == "prod" ]; then
	qs_output_clean "$QUICKPROD_FILEBASE"
	qs_vbox_clean "$QUICKPROD_VBOX"
elif [ "$1" == "dev" ]; then
	qs_output_clean "$QUICKDEV_FILEBASE"
	qs_vbox_clean "$QUICKDEV_VBOX"
else 
	echo " Usage:  $0 [ test | prod | dev ]"
fi

