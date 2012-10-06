#!/bin/bash

## NOTE: You do not need to do this if you want to *use* Quickstart.  
#
#  You can save yourself some time with the instructions here:
#
#  http://<url>


## This script will build a Quickstart Development Environment
#
# The Quickstart 3.0 build environment is Ubuntu 12.04.
# If you're not using Ubuntu 12.04, this may not work.
#
# Documentation: http://<url>
#
# Look for output files in your home folder!



# ############################################## User configurable settings

# Packaging variables
QS_VERSION="3.0"
QS_VERSION_NODOTS="3_0"
QUICKSTART_ORGANIZATION="Drupal Quickstart"
QUICKSTART_URL="DrupalQuickstart.org"

# Linux user to be created.  /home/quickstart
QS_USER="quickstart"

# Machine hostname
QS_HOST_NAME="qs$QS_VERSION_NODOTS" 

# Name of Virtual Machine in Virtualbox
QS_VBOX_NAME="QuickBuild $QS_VERSION (build-hash $RANDOM)" 

# Desktop(s) to load and configure: Cinnamon, Gnome
QS_DESKTOPS="All"

# Development projects to load: All, Drupal, Symfony
QS_PROJECTS="All"

# Which images to build: All, DevLocal, TestLocal, ProdLocal
QS_IMAGES="All"

# Where should the files go?
QS_OUTPUT="$HOME"


# ############################################## The "Plan"
#
# 1) QuickTest: Build (working copy is called QuickBuild)
# 2) QuickTest: Export Vagrant and Virtualbox

# 3) QuickProd: Build (configure with config tool)
# 4) QuickProd: Export Vagrant and Virtualbox

# 5) QuickDev:  Build (add desktops)
# 6) QuickDev:  Export Vagrant and Virtualbox


# ############################################## Build script - do not modify

## Confirmation

echo "
*** Do you want to build Quickstart 3.x with: 
  * Version:      $QS_VERSION
  * Linux User:   $QS_USER
  * Host name:    $QS_HOST_NAME
  * VBox name:    $QS_VBOX_NAME
  * Desktops:     $QS_DESKTOPS
  * Dev projects: $QS_PROJECTS
  * Images:       $QS_IMAGES

THIS WILL DELETE ANY IMAGES IN PROGRESS!

Debugging?  Consider using $ bash -x build.sh
"
read -p "Press enter to continue or ctrl-c to quit"


## Config variables: 

# Set variables for Puppet.  Puppet Facter makes available in .pp
FACTER_quickstart_version=QS_VERSION
FACTER_quickstart_user=QS_USER
FACTER_quickstart_host_name=QS_HOST_NAME
FACTER_quickstart_vbox_name=QS_VBOX_NAME
FACTER_quickstart_desktops=QS_DESKTOPS
FACTER_quickstart_projects=QS_PROJECTS
FACTER_quickstart_images=QS_IMAGES

# Packaging variables.  File names would have extension .ova for vbox and .box for vagrant.
QUICKTEST_VBOX_NAME="QuickTest $QS_VERSION"
QUICKTEST_FILE_NAME="QuickTest.$QS_VERSION"
QUICKPROD_VBOX_NAME="QuickProd $QS_VERSION"
QUICKPROD_FILE_NAME="QuickProd.$QS_VERSION"
QUICKDEV_VBOX_NAME="QuickDev $QS_VERSION"
QUICKDEV_FILE_NAME="QuickDev.$QS_VERSION"


## Build Tools: Install VirtualBox, Vagrant, and Python if necessary

# Verify/install Virtualbox   https://www.virtualbox.org/wiki/Downloads
command -v VBoxManage >/dev/null 2>&1 || { sudo apt-get update; sudo apt-get install virtualbox; }
# Verify/install vagrant      http://downloads.vagrantup.com/
command -v vagrant >/dev/null 2>&1 || { sudo apt-get install vagrant; }
# Verify/install python
command -v python >/dev/null 2>&1 || { sudo apt-get install python; }

## Get private key for vagrant.  We'll need this to setup non-vagrant ssh later.
if [ ! -e ~/.ssh/vagrant ]; then wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant -O ~/.ssh/vagrant; fi
chmod 600 ~/.ssh/vagrant
ssh-add ~/.ssh/vagrant

## Clean up a running build
vagrant halt
vagrant destroy --force


echo "=========================================== 1) QuickTest: Build"

# Execution goes to /Vagrantfile
#  Vagrant downloads and caches Ubuntu 12.04 LTS box from vagrantup.com
#  Vagrantfile runs /manifests/build/QuickBuild.pp
#  Just bootstrap essential virtual machine configuration.
vagrant up

# Get the Virtualbox name from .vagrant using python's json parser - IMPORTANT!
QUICKBUILD_VBOX_NAME=`cat .vagrant | python -c 'import json,sys;obj=json.loads(sys.stdin.read());print obj["'"active"'"]["'"default"'"]'`

# Build QuickTest server
vagrant ssh -c "echo Go for QuickProd"

# The QuickTest VM has been built and configured.  Shutdown to use any new kernel updates
vagrant halt


echo "=========================================== 2) QuickTest: Export Vagrant and Virtualbox"

## Packaging functions we'll use again later

quickstart_vbox_destroy() {
	vboxmanage controlvm "$1" poweroff 2> /dev/null; sleep 5
	vboxmanage unregistervm "$1" --delete 2> /dev/null
}

quickstart_package() {

	## Packaging
	#  Vagrant puts an insecure private key in authorized_keys.  We need to remove the key for ova packaging
	#  Once we remove the key, we won't be able to connect again, so we make a copy

	# Shutdown
	vagrant halt

	# Clean up
	quickstart_vbox_destroy "$2"
	QS_BOXFILE="$QS_OUTPUT"/"$3.box"
	QS_OVAFILE="$QS_OUTPUT"/"$3.ova"
	rm -f "$QS_BOXFILE"
	rm -f "$QS_OVAFILE"

	## Make a copy
	vboxmanage clonevm "$1" --name "$2" --register

	## Package with Vagrant
	vagrant package --base "$2" --output "$QS_BOXFILE"

	if [ ! -e "$QS_BOXFILE" ]; then echo "Failed to export $QS_BOXFILE"; exit 1; fi

	## Package with Vbox - remove vagrant ssh public key

	# Switching to guns.  After we cloned the VM, we can't use vagrant any more.  We have to ssh the hard way.  configure ssh
	vboxmanage modifyvm "$2" --natpf1 "guestssh,tcp,127.0.0.1,2223,,22"
	vboxmanage startvm "$2"; sleep 20

	# Remove vagrant ssh public key.  No way for vagrant to login ssh after this
	ssh -p 2223  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@127.0.0.1 "rm ~/.ssh/authorized_keys; sudo poweroff"

	# Wait for power off
	sleep 10; 

	# unconfigure ssh
	vboxmanage modifyvm "$2" --natpf1 delete "guestssh"

	# Export the file
	vboxmanage export "$2" --output "$QS_OVAFILE" \
	  --manifest \
	  --vsys 0 \
	    --product "$2"  \
	    --producturl "$QUICKSTART_URL"    \
	    --vendor "$QUICKSTART_ORGANIZATION"  \
	    --vendorurl "$QUICKSTART_URL"  \
	    --version "$QS_VERSION"

	if [ ! -e "$QS_OVAFILE" ]; then echo "Failed to export $QS_OVAFILE"; exit 1; fi

	# Remove copy
	quickstart_vbox_destroy "$2"
}

quickstart_package "$QUICKBUILD_VBOX_NAME" "$QUICKTEST_VBOX_NAME" "$QUICKTEST_FILE_NAME" 

echo "=========================================== 3) QuickProd: Build (configure with config tool)"
## back to vagrant build box
vagrant up
vagrant ssh -c "echo Go for QuickProd"
vagrant halt

echo "=========================================== 4) QuickProd: Export Vagrant and Virtualbox"
quickstart_package "$QUICKBUILD_VBOX_NAME" "$QUICKPROD_VBOX_NAME" "$QUICKPROD_FILE_NAME" 

echo "=========================================== 5) QuickDev:  Build (add desktops)"
vagrant up
vagrant ssh -c "echo Go for QuickDev"
vagrant halt

echo "=========================================== 6) QuickDev:  Export Vagrant and Virtualbox"
quickstart_package "$QUICKBUILD_VBOX_NAME" "$QUICKDEV_VBOX_NAME" "$QUICKDEV_FILE_NAME" 

echo "=========================================== Clean up"
vagrant halt
vagrant destroy --force
quickstart_vbox_destroy "$QUICKTEST_VBOX_NAME"
quickstart_vbox_destroy "$QUICKPROD_VBOX_NAME"
quickstart_vbox_destroy "$QUICKDEV_VBOX_NAME"
quickstart_vbox_destroy "$QUICKBUILD_VBOX_NAME"
