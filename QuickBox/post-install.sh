#!/bin/bash

# See https://bugs.launchpad.net/ubuntu/+bug/1009294
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc
sudo apt-get -yq update
sudo apt-get -yq upgrade
sudo apt-get -yq autoremove

# Use the generic kernel instead of server.
sudo apt-get -yq install linux-image-generic linux-headers-generic virtualbox-guest-x11

# ruby-shadow installed here because otherwise can't set user password  
sudo apt-get -yq install puppet ruby-full rubygems augeas-tools libaugeas-ruby
sudo gem install ruby-shadow; 

