#!/bin/bash

echo "*** Cleaning QuickBase"

# ############################################## Get settings
. settings.sh

echo "** Halt QuickBase if running ..."
vagrant halt 2> /dev/null

echo "** Destroy QuickBase Vagrant ..."
vagrant destroy --force

rm -f .vagrant

echo "**   ...  Done"


