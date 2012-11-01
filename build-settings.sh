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
QS_OUTPUT="."

# ############################################## VBox and File names

# Packaging variables.  File names would have extension .ova for vbox and .box for vagrant.

# Name of Virtual Machine in Virtualbox
QUICKBASE_VBOX="QuickBase $QS_VERSION" 
QUICKTEST_VBOX="QuickTest $QS_VERSION"
QUICKPROD_VBOX="QuickProd $QS_VERSION"
QUICKDEV_VBOX="QuickDev $QS_VERSION"

QUICKBASE_FILE="QuickBase.$QS_VERSION"
QUICKTEST_FILE="QuickTest.$QS_VERSION"
QUICKPROD_FILE="QuickProd.$QS_VERSION"
QUICKDEV_FILE="QuickDev.$QS_VERSION"

# Quicksprint settings
QUICKSPRINT_FILE="QuickSprint.$QS_VERSION"
VBOX_HOST_WINDOWS_URL="http://files.vagrantup.com/packages/aafa79fe66db687da265d790d5e67a2a7ec30d92/vagrant_1.0.0_i686.rpm"
VBOX_HOST_MAC_URL="http://files.vagrantup.com/packages/aafa79fe66db687da265d790d5e67a2a7ec30d92/vagrant_1.0.0_i686.rpm"


# ############################################## Install Build Tools

## Build Tools: Install VirtualBox, Vagrant, and Python if necessary

# Verify/install Virtualbox   https://www.virtualbox.org/wiki/Downloads
command -v VBoxManage >/dev/null 2>&1 || { echo "Installing virtualbox..."; sudo apt-get -yqq update; sudo apt-get -yqq install virtualbox; }
# Verify/install vagrant      http://downloads.vagrantup.com/
command -v vagrant >/dev/null 2>&1 || { echo "Installing vagrant..."; sudo apt-get -yqq update; sudo apt-get -yqq install vagrant; }
# Verify/install python
command -v python >/dev/null 2>&1 || { echo "Installing python..."; sudo apt-get -yqq update; sudo apt-get -yqq install python; }
# Verify/install genisoimage (for QuickSprint.iso)
command -v genisoimage >/dev/null 2>&1 || { echo "Installing python..."; sudo apt-get -yqq update; sudo apt-get -yqq install genisoimage; }

## Get private key for vagrant.  We'll need this to setup non-vagrant ssh later.
if [ ! -e ~/.ssh/vagrant ]; then wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant -O ~/.ssh/vagrant; fi
chmod 600 ~/.ssh/vagrant



# ############################################## Find working copy (if available)

# Get the Virtualbox name from .vagrant using python's json parser - this may not be valid.
qs_get_base_uuid() {
	if [ -f ".vagrant" ]; then
		QUICKBASE_UUID=`cat .vagrant | python -c 'import json,sys;obj=json.loads(sys.stdin.read());print obj["'"active"'"]["'"default"'"]'`
	fi
}

# ############################################## Puppet settings and commands

# Set variables for Puppet.  Puppet Facter makes these available in QuickBase.pp shell commands
# These are written to /var/quickstart/config.sh at the bottom of QuickBase.pp
FACTER_QS_VERSION=QS_VERSION
FACTER_QS_USER=QS_USER
FACTER_QS_HOSTNAME=QS_HOSTNAME
FACTER_QS_DESKTOPS=QS_DESKTOPS
FACTER_QS_PROJECTS=QS_PROJECTS

# Configuration commands - passed through ssh
QS_GO_QUICKTEST=". config-quicktest.sh"
QS_GO_QUICKPROD=". config-quickprod.sh"
QS_GO_QUICKDEV=". config-quickdev.sh"


# ############################################## Confirmation
if [ -z $QS_CONFIRM ]; then echo "
********************************************************************************************************

*** $0 $*

*** Settings:
  * Version:      $QS_VERSION
  * Linux User:   $QS_USER
  * Host name:    $QS_HOSTNAME
  * VBox name:    $QUICKBASE_VBOX
  * Desktops:     $QS_DESKTOPS
  * Dev projects: $QS_PROJECTS
  * Output:       $QS_OUTPUT

Debugging?  Consider running this script with $ bash -x $0 $*

Strange errors?  Did you run out of disk space? 
"
df -h $QS_OUTPUT
echo ""
QS_CONFIRM=done
read -p "Press enter to continue or ctrl-c to quit"
fi


