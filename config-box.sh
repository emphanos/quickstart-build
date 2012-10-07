#!/bin/bash

echo "*** Configuring $1"

# ############################################## Get settings
. build-settings.sh

# ############################################## Build

if [ "$1" == "Base" ]; then
	echo "** Building working copy in vagrant: $1  ..."

	vagrant up
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant up error"; fi

	qs_get_base_uuid

	vagrant halt

	echo "**   ...  Done"
fi

if [ "$1" == "Test" ]; then
	echo "** Building working copy in vagrant: $1  ..."

	vagrant up
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant up error"; exit; fi

	qs_get_base_uuid

	vagrant ssh -c "$QS_GO_QUICKTEST"
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant ssh error"; exit; fi

	vagrant halt

	echo "**   ...  Done"
fi

if [ "$1" == "Prod" ]; then
	echo "** Building working copy in vagrant: $1  ..."

	vagrant up
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant up error"; exit; fi

	qs_get_base_uuid

	vagrant ssh -c "$QS_GO_QUICKPROD"
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant ssh error"; exit; fi

	vagrant halt

	echo "**   ...  Done"
fi

if [ "$1" == "Dev" ]; then
	echo "** Building working copy in vagrant: $1  ..."

	vagrant up
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant up error"; return; fi

	qs_get_base_uuid

	vagrant ssh -c "$QS_GO_QUICKDEV"
	if [ $? -gt 0 ]; then QS_ERROR="Vagrant ssh error"; return; fi
	vagrant halt

	echo "**   ...  Done"
fi

