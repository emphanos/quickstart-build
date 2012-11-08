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


# ############################################## Get settings
. settings.sh

# ############################################## Build everything

# Build the base image
. quickbase-build.sh
. quickimage-build.sh test
#. quickimage-build.sh prod  This will happen in a future release
. quickimage-build.sh dev
. quicksprint-build.sh

. finish.sh build-all.sh



