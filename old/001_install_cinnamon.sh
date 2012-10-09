#!/bin/bash

# install Cinnamon 1.6 on Ubuntu 12.04 LTS

sudo apt-get -yq install python-software-properties
sudo add-apt-repository -y ppa:gwendal-lebihan-dev/cinnamon-stable
sudo apt-get -yq update
sudo apt-get -yq install cinnamon ubuntu-desktop gnome-session lightdm unity-greeter
sudo dpkg-reconfigure ubuntu-desktop
sudo dpkg-reconfigure lightdm
sudo reboot

# Also install applets:
# netspeed: http://cinnamon-spices.linuxmint.com/applets/view/18
# sudo apt-get -yq install gir1.2-gtop-2.0
# wget http://cinnamon-spices.linuxmint.com/uploads/applets/EH5A-ZJV6-7X3E.zip
# unzip and to ~/.local/share/cinnamon/applets/



# weather: http://cinnamon-spices.linuxmint.com/applets/view/17
# wget http://cinnamon-spices.linuxmint.com/uploads/applets/F2T7-5UAV-Q11M.zip
# unzip to temp
# bash install.sh


# hardware: http://cinnamon-spices.linuxmint.com/applets/view/12
# sudo apt-get -yq install gir1.2-gtop-2.0
# wget http://cinnamon-spices.linuxmint.com/uploads/applets/3QIF-VVTI-L59J.zip
# unzip to ~/.local/share/cinnamon/applets/


# interesting stuff here
# http://www.techsupportalert.com/content/tips-and-tricks-mint-after-installation-mint-13-cinnamon-edition.htm#Enable-Disable-Applets-on-the-Panel

# Document some shortcuts
echo "CTRL+ALT+UP goes to Expo
CTRL+ALT+DOWN goes to Scale
The hot corner is on the top-left and calls Expo
CTRL+ALT+LEFT/RIGHT switches to the LEFT/RIGHT adjacent workspace
CTRL+ALT+SHIFT+LEFT/RIGHT moves the active window to the LEFT/RIGHT adjacent workspace"
