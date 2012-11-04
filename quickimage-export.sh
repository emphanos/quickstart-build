#!/bin/bash

echo "*** Exporting $1"

# ############################################## Get settings
. settings.sh

# ############################################## Export one

## Export .ova and .box files.  
qs_export() {
	#  Usage: qs_package "$QUICKBASE_VBOX" "$QUICKTEST_VBOX" "$QUICKTEST_FILEBASE" 
	#  Uses $QS_CLEAN, $QS_ORGANIZATION, $QS_URL, $QS_VERSION

	## Packaging
	#  Vagrant puts an insecure private key in authorized_keys.  We need to remove the key for ova packaging
	#  Once we remove the key, we won't be able to connect again, so we make a copy
	#  The virtual machine is an artifact of the output files.  It will get destroyed if they need to be rebuilt

	# Shutdown
	vagrant halt

	# Variables
	QS_BOXFILE="$QS_OUTPUT"/"$3.box"
	QS_OVAFILE="$QS_OUTPUT"/"$3.ova"

	## Make a copy
	echo "** Removing export copy: $2  ..."
	qs_vbox_clean "$2"
	echo "**   ...  Done"

	echo "** Copying working copy: $1 to export copy: $2  ..."

	# if vagrant hasn't been "up" we won't know it's uuid.  so we have to boot it to find out.
	if [ -z "$1" ]; then
		vagrant up
		qs_get_base_uuid
		vagrant halt
	fi

	vboxmanage clonevm "$1" --name "$2" --register
	if [ $? -gt 0 ]; then echo "*** !!! VBoxManage clonevm error"; exit; fi
	echo "**   ...  Done"

	## Remove old files
	echo "** Removing export images: $QS_BOXFILE $QS_OVAFILE ..."
	rm -f "$QS_BOXFILE"
	rm -f "$QS_OVAFILE"
	echo "**   ...  Done"
	
	## Package with Vagrant
	echo "** Exporting export copy: $2 to $QS_BOXFILE ..."
	vagrant package --base "$2" --output "$QS_BOXFILE"
	if [ ! -e "$QS_BOXFILE" ]; then echo "!!!!! Failed to export $QS_BOXFILE"; exit 1; fi
	echo "**   ...  Done"

	## Package with Vbox - remove vagrant ssh public key

	# Maverick: Too close for missles, I'm switching to guns.
        # After we cloned the VM, we can't use vagrant any more.  We have to ssh the hard way.  configure ssh
	echo "** Exporting export copy $2 to $QS_OVAFILE ..."

	echo "* Booting to remove vagrant well-known private key from $2"
	vboxmanage modifyvm "$2" --natpf1 "guestssh,tcp,127.0.0.1,2223,,22"
	vboxmanage startvm "$2"; sleep 20

	# Remove vagrant ssh public key.  No way for vagrant to login ssh after this
	ssh-add ~/.ssh/vagrant
	ssh -p 2223  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@127.0.0.1 "rm ~/.ssh/authorized_keys; sudo poweroff"

	# Wait for power off
	sleep 10; 

	# unconfigure ssh
	vboxmanage modifyvm "$2" --natpf1 delete "guestssh"

	# Export the file
	echo "* Exporting ova"
	vboxmanage export "$2" --output "$QS_OVAFILE" \
	  --manifest \
	  --vsys 0 \
	    --product "$2"  \
	    --producturl "$QS_URL"    \
	    --vendor "$QS_ORGANIZATION"  \
	    --vendorurl "$QS_URL"  \
	    --version "$QS_VERSION"

	if [ ! -e "$QS_OVAFILE" ]; then echo "Failed to export $QS_OVAFILE"; exit 1; fi
	echo "**   ...  Done"
}

if [ "$1" == "test" ]; then
	qs_export "$QUICKBASE_UUID" "$QUICKTEST_VBOX" "$QUICKTEST_FILEBASE"
elif [ "$1" == "prod" ]; then
	qs_export "$QUICKBASE_UUID" "$QUICKPROD_VBOX" "$QUICKPROD_FILEBASE"
elif [ "$1" == "dev" ]; then
	qs_export "$QUICKBASE_UUID" "$QUICKDEV_VBOX" "$QUICKDEV_FILEBASE"
else
	echo "Usage: $0 [ test | prod | dev ]"
fi

