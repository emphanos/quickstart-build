quickstart-build
================

The build scripts for creating the Quickstart images.

To build everything: 

$ bash build.sh 

To debug, include -x on any bash command.  E.g. bash -x build.sh

=== To build an official version

1) Update settings.sh
 - Update Quickstart strings (QS_VERSION, QS_VERSION_NODOTS)
 - Update the QuickSprint image file /QuickSprint/Disk-Label.xcf (Gimp)
 - Check virtualbox installer download strings (www.virtualbox.org)

2) Run the build script
 - bash build-all.sh 

=== Overview

The build is broken into several steps.  Steps were chosen on where work could be easily cached:
 * Ubuntu 12.04 image download
   - Download and Cache "precise64" Vagrant box from VagrantUp.com.
   - https://github.com/quickstart/quickstart-build/blob/dev/QuickBox/Vagrantfile
   - This happens internally in Vagrant.  To clear cache: vagrant box remove precise64
   - Built automatically in build scripts
 * QuickBox
   - Basic Ubuntu install.  Run updates and cache locally (don't dl 200mb every test run)
   - QuickBase is as close to a physical install of Ubuntu as possible to enable using QS outside a VM
   - https://github.com/quickstart/quickstart-build/blob/dev/QuickBox/rebuild.sh
   - This happens internally in Vagrant.  To clear cache: vagrant box remove QuickBox
   - Built automatically in build scripts
 * QuickBase
   - Minimum bootstrap to run quickstart-configure build scripts
   - Quickstart user, working dir, minimal packages, git clone quickstart-configure
   - https://github.com/quickstart/quickstart-build/blob/dev/quickbase-config.sh
   - Makes a VBox "snapshot" that QuickTest/QuickProd/QuickDev restore before building.
   - To clear cache: bash quickbase-clean.sh
   - Built automatically in build scripts
 * QuickTest
   - Build a headless development lamp server configured for testing
   - https://github.com/quickstart/quickstart-build/blob/dev/quickimage-config.sh
   - To clear cache: bash quickimage-clean.sh test
   - To build: bash quickimage-build.sh test
   - Will automatically build missing previous steps.  Restores snapshot of Quickbase
 * QuickDev
   - Configure the server for desktop development
   - https://github.com/quickstart/quickstart-build/blob/dev/quickimage-config.sh
   - To clear cache: bash quickimage-clean.sh test
   - To build: bash quickimage-build.sh test
   - Will automatically build missing previous steps.  Restores snapshot of Quickbase

Packaging and publishing:
 * QuickSprint
   - QuickSprint is an ISO designed for use in sprints.  We're collaborating with Drupal Ladder to offer this for people organizing sprints.
   - It's an ISO with the QuickDev.ova, a download of the Windows and Mac VBox installer, and files in the QuickSprint folder
 * publish-all.sh 
   - scp's the files to Drupal Quickstart's account at OSUOSL.  Requires private key to work.


=== 0) Ubuntu 12.04 LTS 64 bit "precise64" image from vagrantup.com

Download and Cache "precise64" Vagrant box from VagrantUp.com.

   - This happens internally in Vagrant.
   - https://github.com/quickstart/quickstart-build/blob/dev/QuickBox/Vagrantfile
   - To clear cache: vagrant box remove precise64
   - Built automatically in build scripts

=== 1) QuickBox

Download all official updates and repackage image as QuickBox.  This saves time during development by caching updates locally.

   - Basic Ubuntu install.  Run updates and cache locally
   - QuickBase is as close to a physical install of Ubuntu as possible to enable using QS outside a VM
   - https://github.com/quickstart/quickstart-build/blob/dev/QuickBox/rebuild.sh
   - This happens internally in Vagrant.  To clear cache: vagrant box remove QuickBox
   - Built automatically in build scripts

=== 2) QuickBase

The purpose of QuickBase is to build a minimumly viable system for Puppet customization.  

For a non-virtual installation, all the QuickBase steps would be done manually.

   - Quickstart user, working dir, minimal packages, git clone quickstart-configure
   - Minimum bootstrap to run quickstart-configure build scripts
   - https://github.com/quickstart/quickstart-build/blob/dev/quickbase-config.sh
   - Makes a VBox "snapshot" that QuickTest/QuickProd/QuickDev restore before building.
   - To clear cache: bash quickbase-clean.sh
   - Built automatically in build scripts

=== 3) QuickTest

Build a headless development lamp server configured for testing.  Uses a config.sh script in quickstart-configure repo.

   - https://github.com/quickstart/quickstart-build/blob/dev/quickimage-config.sh
   - Restores snapshot of QuickBase (to clear any previous config)
   - https://github.com/quickstart/quickstart-configure/blob/master/config.sh

   - To clear cache: bash quickimage-clean.sh test
   - To build: bash quickimage-build.sh test
   - Will automatically build missing previous steps
   - Will export QuickTest.box and QuickTest.ova files 

During export, and "export copy" VM is made, so the images can be secured (remove the insecure Vagrant private key (link).
The .box files are always insecure with ssh, but can work with Vagrant.
The .ova files remove this security hole, and can be imported manually into Virtualbox

=== 4) QuickDev

Build a desktop development environment.  Uses same scripts as QuickTest, just different puppet file.

   - https://github.com/quickstart/quickstart-build/blob/dev/quickimage-config.sh
   - Restores snapshot of QuickBase (to clear any previous config)
   - https://github.com/quickstart/quickstart-configure/blob/master/config.sh

   - To clear cache: bash quickimage-clean.sh dev
   - To build: bash quickimage-build.sh dev
   - Will automatically build missing previous steps
   - Will export QuickTest.box and QuickTest.ova files 

During export, and "export copy" VM is made, so the images can be secured (remove the insecure Vagrant private key (link).
The .box files are always insecure with ssh, but can work with Vagrant.
The .ova files remove this security hole, and can be imported manually into Virtualbox

