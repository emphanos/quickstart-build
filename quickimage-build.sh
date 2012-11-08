#!/bin/bash

# ############################################## Get settings
. settings.sh

# ############################################## Build
. quickimage-clean.sh $1
. quickimage-config.sh $1

# Don't package a broken build
if [ ! -z "$QS_ERROR" ]; then echo "$QS_ERROR"; exit 100; fi

. quickimage-export.sh $1

. finish.sh quickimage-build.sh

