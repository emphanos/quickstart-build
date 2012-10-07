#!/bin/bash

echo "*** Cleaning $1"

# ############################################## Get settings
. build-settings.sh

## Destroy a vm in Virtualbox.  Suppress "does not exist" errors.  
qs_vbox_clean() {
	#  Usage: qs_vbox_clean "$QUICKTEST_VBOX"
	#  Does NOT use $QS_CLEAN
	echo "** Removing output virtualbox image: $1  ..."
	vboxmanage controlvm "$1" poweroff 2> /dev/null; sleep 5
	vboxmanage unregistervm "$1" --delete 2> /dev/null
	echo "**   ...  Done"
}

## Clean output files
qs_output_clean() {
	echo "** Removing output files:" "$QS_OUTPUT"/"$1.box" "$QS_OUTPUT"/"$1.ova"
	#  Usage: qs_output_clean "$QUICKTEST_FILE"
	#  Uses: $QS_OUTPUT.  Does NOT use $QS_CLEAN.
	rm -f "$QS_OUTPUT"/"$1.box"
	rm -f "$QS_OUTPUT"/"$1.ova"
	echo "**   ...  Done"
}

# ############################################## Clean Build is cleaning vagrant
if [ "$1" == "Base" ]; then
	## Stop if already started!
	qs_output_clean "$QUICKBASE_FILE"
	qs_vbox_clean "$QUICKBASE_VBOX"
	echo "** Removing working copy image from vagrant ..."
	vagrant halt 2> /dev/null
	vagrant destroy --force
	echo "**   ...  Done"
fi

if [ "$1" == "Test" ]; then
	qs_output_clean "$QUICKTEST_FILE"
	qs_vbox_clean "$QUICKTEST_VBOX"
fi

if [ "$1" == "Prod" ]; then
	qs_output_clean "$QUICKPROD_FILE"
	qs_vbox_clean "$QUICKPROD_VBOX"
fi

if [ "$1" == "Dev" ]; then
	qs_output_clean "$QUICKDEV_FILE"
	qs_vbox_clean "$QUICKDEV_VBOX"
fi

