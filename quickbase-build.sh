#!/bin/bash

# ############################################## Build Quickbase
# QuickBase is the base image all other images are built from.

# ############################################## Get settings
. settings.sh

# ############################################## Build
. quickbase-clean.sh
. quickbase-config.sh

