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
QS_GO_QUICKTEST="echo ==== CONFIGURE QUICKTEST"
QS_GO_QUICKPROD="echo ==== CONFIGURE QUICKPROD"
QS_GO_QUICKDEV="echo ==== CONFIGURE QUICKDEV"


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

"
QS_CONFIRM=done
read -p "Press enter to continue or ctrl-c to quit"
fi

