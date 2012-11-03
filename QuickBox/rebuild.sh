#!/bin/bash

# rebuild the Vagrant box used for Quickstart.  Frontload as much download and update as possible.

# Force a rebuild from original bits.  Should be unnecessary, but whatever.
FORCE=$1

echo "*** Cleaning QuickBox"
if [ "$FORCE" == "force" ]; then
  echo "** Forcing re-download from vagrant.com"
  vagrant box remove precise64
fi
vagrant box remove QuickBox 2> /dev/null
rm -f QuickBox.box  # after vagrant box add below, this file can be deleted

echo "*** Rebuilding QuickBox"
vagrant halt 2> /dev/null
vagrant destroy -f

echo " * This error is ok.  See QuickBox Vagrantfile.  /usr/sbin/grub-probe: error: cannot stat /dev/disk/by-id/ata-VBOX_HARDDISK_VB99bad0f8-38d48ed5."
vagrant up

vagrant halt

echo "*** Packaging QuickBox"
vagrant package --output QuickBox.box

echo "*** Adding Quickbox to Vagrant"
vagrant box add QuickBox QuickBox.box

echo "*** Cleaning up working files and images"
rm -f QuickBox.box
vagrant destroy -f

echo "*** QuickBox rebuild Done!"

