/** This file is responsible for preparing the image for configuration
 *
 * - download and applying OS updates
 * - install basic tools: git, puppet, ruby-full, rubygems
 * - configure the "quickstart" user 
 * - clone the configuration repository
 * 
 * Once complete, execution drops back to Vagrantfile, then build.sh continues.
 *
 * This file should be re-entrant.  I.e. run it 20 times and get same result each time
 *
 * To debug: 
vagrant up; vagrant ssh
sudo puppet apply --debug /tmp/vagrant-puppet/manifests/build/QuickBase.pp 
 */

/* Default resource properties */
File { owner => 0, group => 0, mode => 0644 }
Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }

/* entry point */
node default {
  include params
  include bootstrap
}

