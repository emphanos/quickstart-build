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

# Build everything else
. clean-box.sh Base
. clean-box.sh Test
. clean-box.sh Prod
. clean-box.sh Dev
. clean-iso.sh




