#!/bin/bash

. settings.sh

scp $QS_OUTPUT/* drupal-quickstart@ftp-osl.osuosl.org:data

