#!/bin/bash

echo "*** Configuring QuickBase"

# ############################################## Get settings
. settings.sh

echo "# params.pp configuration file.  Written on each execute of $0
class params {
  \$version = '$QS_VERSION'
  \$version_nodots = '$QS_VERSION_NODOTS'
  \$username = '$QS_USER'
  \$hostname = 'qs$QS_VERSION_NODOTS'
}" > QuickBase/puppet/manifests/params.pp


# ############################################## Build
echo "** Building QuickBase working copy in vagrant ..."

vagrant up --provision
if [ $? -gt 0 ]; then QS_ERROR=" !!! Vagrant up error"; exit; fi

echo "** Shutting down VM ..."
vagrant halt

# We will come back to this snapshot when making each quickimage(test,dev,prod)
echo "** Making snapshot of QuickBase ..."
qs_get_base_uuid
vboxmanage snapshot $QUICKBASE_UUID take quickbase
if [ $? -gt 0 ]; then QS_ERROR=" !!! Vboxmanage error"; exit; fi

. finish.sh quickbase-config.sh


