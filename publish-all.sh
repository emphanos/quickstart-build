#!/bin/bash

if [ -f ~/.ssh/mc-desktop_rsa ] ; then  
	. settings.sh

	scp $QS_OUTPUT/*.iso drupal-quickstart@ftp-osl.osuosl.org:data
	scp $QS_OUTPUT/*.ova drupal-quickstart@ftp-osl.osuosl.org:data
	ssh drupal-quickstart@ftp-osl.osuosl.org "chmod 644 data/*"
	. finish.sh publish-all.sh
fi
