#!/bin/bash

echo "*** Replacing QuickBase Snapshot with current state"

# ############################################## Snapshot
#
# Replace quickbase snapshot with current state
#
# Useful in quickimage testing to not redownload/configure cinnamon/lamp/whatever
. settings.sh

echo "** Shutting down VM ..."
vagrant halt

# We will come back to this snapshot when making each quickimage(test,dev,prod)
echo "** Making snapshot of QuickBase ..."
qs_get_base_uuid
vboxmanage snapshot $QUICKBASE_UUID take testing
if [ $? -gt 0 ]; then QS_ERROR=" !!! Vboxmanage error"; exit; fi

. finish.sh quickbase-config.sh


