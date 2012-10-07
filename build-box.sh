#!/bin/bash

# ############################################## Build one stage
# build-box.sh [Base|Test|Prod|Dev]

# ############################################## Get settings
. build-settings.sh

# ############################################## Build
. clean-box.sh $1
. config-box.sh $1

# Don't package a broken build
if [ ! -z "$QS_ERROR" ]; then echo "$QS_ERROR"; exit 100; fi

. export-box.sh $1

