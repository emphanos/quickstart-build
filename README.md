quickstart-build
================

The build scripts for creating the Quickstart images.

To build everything: 

$ bash build.sh 

To debug, include -x on any bash command.  E.g. bash -x build.sh


There are 5 stages to the build:

=== 1) QuickBox

This is a Vagrant "Box" image of Ubuntu 12.04 LTS with no customization.
The purpose of this step is to do as much downloading as possible before configuration, then cache that as a Vagrant "Box" locally

 - based on vagrantup.com's: http://files.vagrantup.com/precise64.box
 - updates downloaded and applied
 - exported and added in Vagrant as "QuickBox"

QuickBox has a separate Vagrantfile and a rebuild.sh in the QuickBox directory.
This can be rerun if your spending alot of time waiting for initial updates to download and install.

 - bash -x BaseBox/rebuild.sh

This step could be enhanced with VeeWee.


=== 2) QuickBase

This is a Vagrant installation of QuickBox.  The Vagrant copy is the "working copy" for customizing the images.  

The purpose of QuickBuild is to build a minimumly viable system for Puppet customization.

During export, and "export copy" VM is made, so the images can be secured (remove the insecure Vagrant private key (link).

 - based on QuickBox
 - installs packages
 - creates quickstart user
 - git clones puppet repo: quickstart-configure

QuickBuild is a "Working Copy" image configured by Puppet.
The Puppet script "QuickBuild" is run on every "vagrant up" so it's meant to be lean, mean, and re-entrant.
This step rebuilds the Vagrant "working copy" image that is customized by QuickTest, QuickProd, and QuickDev.

The build can be interacted with using:

	$ bash build-box.sh Build   - clean, config, export

	$ bash clean-box.sh Build   - clean the vagrant working copy, QuickBuild export copy, exported files
	$ bash config-box.sh Build  - rebuild the "Working Copy"
	$ bash export-box.sh Build  - copy the "working copy" to QuickBuild export copy, then export files


3,4,5) QuickTest, QuickProd, QuickDev

These are the project deliverables described in the Design and Requirements section.

They use similar commands.

	$ bash build-box.sh [Test|Prod|Dev]   - clean, config, export

	$ bash clean-box.sh [Test|Prod|Dev]   - clean, the export copy, exported files.  Leaves the working copy.
	$ bash config-box.sh [Test|Prod|Dev]  - reconfigure the "working copy" using Puppet scripts.  Will rebuild "working copy" if necessary
	$ bash export-box.sh [Test|Prod|Dev]  - copy the "working copy" to export copy, then export files

Note that the "working copy" Vagrant image has state.  Running the steps out of order may include unwanted config and files.

$ bash build-box.sh QuickDev
$ bash build-box.sh QuickProd
$ bash bulld-box.sh QuickTest

May not produce what you want.
