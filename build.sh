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


# ############################################## Install Build Tools

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


# ############################################## Get settings
. build-settings.sh

# ############################################## Build everything

# Check for QuickBox in list of available vagrant boxes.  Rebuild if not there
if [ -z `vagrant box list | grep QuickBox` ]; then
  echo "*** Rebuilding QuickBox"
  ( cd QuickBox; bash rebuild.sh )  #runs commands in it's own shell
else
  echo "*** Using existing QuickBox.  
 * vagrant box remove QuickBox to force re-update
 * vagrant box remove precise64 to force redownload"
fi

# Build everything else
. build-box.sh Base
. build-box.sh Test
. build-box.sh Prod
. build-box.sh Dev





