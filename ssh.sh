#!/bin/bash

QS_CONFIRM=done
. settings.sh

vagrant up
vagrant ssh -c "sudo -i"


