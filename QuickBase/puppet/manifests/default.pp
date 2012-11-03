/** This file is responsible for preparing the image for configuration
 *
 * These should be the steps to setup a non-virtual machine to use quickstart-configure
 * 
 *  *  - Include params.pp (written out by build-settings.sh)
 *  - Run QuickBase.pp to configure system
 *
 * Once complete, execution drops back to Vagrantfile, then build.sh continues.
 */

/* Default resource properties */
File { owner => 0, group => 0, mode => 0644 }
Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }

/* entry point */
node default {
  include params

  class { "quickbase":
	username => "$params::username",
  }
}

