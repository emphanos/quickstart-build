#!/bin/bash


# ############################################## User configurable settings

# Packaging variables
QS_VERSION="3.0"
QS_VERSION_NODOTS="3_0"
QS_ORGANIZATION="Drupal Quickstart"
QS_URL="http://DrupalQuickstart.org"

# Linux Variables
QS_USER="quickstart"
QS_HOSTNAME="qs$QS_VERSION_NODOTS" 

# Desktop(s) to load and configure: Cinnamon, Gnome
QS_DESKTOPS="All"

# Development projects to load: All, Drupal, Symfony
QS_PROJECTS="All"

# Where should the files go?
QS_OUTPUT="./Output"

# Are we in development mode?  Comment for official mode.  See also VagrantFile and quickimage-config.sh
QS_DEBUG=On

# ############################################## VBox and File names

# Packaging variables.  File names would have extension .ova for vbox and .box for vagrant.

# Name of Virtual Machine in Virtualbox
QUICKTEST_VBOX="QuickTest $QS_VERSION"
QUICKPROD_VBOX="QuickProd $QS_VERSION"
QUICKDEV_VBOX="QuickDev $QS_VERSION"

# Output files (.ova and .box added during export)
QUICKTEST_FILEBASE="QuickTest.$QS_VERSION"
QUICKPROD_FILEBASE="QuickProd.$QS_VERSION"
QUICKDEV_FILEBASE="QuickDev.$QS_VERSION"

# QuickSprint settings
QUICKSPRINT_FILE="QuickSprint.$QS_VERSION.iso"
VBOX_HOST_WINDOWS_URL="http://download.virtualbox.org/virtualbox/4.2.2/VirtualBox-4.2.2-81494-Win.exe"
VBOX_HOST_MAC_URL="http://download.virtualbox.org/virtualbox/4.2.2/VirtualBox-4.2.2-81494-OSX.dmg"


# ############################################## Install Build Tools

## Build Tools: Install VirtualBox, Vagrant, and Python if necessary

# python
command -v python >/dev/null 2>&1 || { echo "Installing python..."; sudo apt-get -yqq update; sudo apt-get -yqq install python; }

# Virtualbox   https://www.virtualbox.org/wiki/Downloads
command -v VBoxManage >/dev/null 2>&1 || { echo "Installing virtualbox..."; sudo apt-get -yqq update; sudo apt-get -yqq install virtualbox; }

# http://downloads.vagrantup.com/
command -v vagrant >/dev/null 2>&1 || { echo "Installing vagrant..."; sudo apt-get -yqq update; sudo apt-get -yqq install vagrant; }

# genisoimage (for QuickSprint.iso)
command -v genisoimage >/dev/null 2>&1 || { echo "Installing genisoimage..."; sudo apt-get -yqq update; sudo apt-get -yqq install genisoimage; }

# Get private key for vagrant.  We'll need this to setup non-vagrant ssh later.
if [ ! -e ~/.ssh/vagrant ]; then wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant -O ~/.ssh/vagrant; fi
chmod 600 ~/.ssh/vagrant



# ############################################## Find working copy (if available)

# Get the Virtualbox name from .vagrant using python's json parser - this may not be valid.
qs_get_base_uuid() {
	if [ -f ".vagrant" ]; then
		QUICKBASE_UUID=`cat .vagrant | python -c 'import json,sys;obj=json.loads(sys.stdin.read());print obj["'"active"'"]["'"default"'"]'`
	fi
}



# ############################################## Confirmation
if [ -z $QS_CONFIRM ]; then echo "
********************************************************************************************************

*** $0 $*

*** Settings:
  * Version:      $QS_VERSION
  * Linux User:   $QS_USER
  * Host name:    $QS_HOSTNAME
  * Desktops:     $QS_DESKTOPS
  * Dev projects: $QS_PROJECTS
  * Output:       $QS_OUTPUT

Debugging?  Consider running this script with $ bash -x $0 $*

Strange errors?  Did you run out of disk space? 
"
df -h $QS_OUTPUT
echo ""
QS_CONFIRM=done
#read -p "Press enter to continue or ctrl-c to quit"
fi


