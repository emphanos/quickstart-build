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

/* download and apply OS updates */
exec {"sudo apt-get -yq update; sudo apt-get -yq upgrade; sudo apt-get -yq autoremove":}

/* install basic tools: git, puppet, ruby-full, rubygems */
package { ['git', 'puppet', 'ruby-full', 'rubygems']:
        ensure => installed,
}
package { "ruby-shadow":
    provider => 'gem',
    ensure => installed,
    require => Package[[rubygems]]
}

/* configure the "quickstart" user  */
user { "quickstart":
  name      => $qs_user,
  ensure    => present,
  password  => $qs_user,
  groups    => ["www-data", "root", "admin"],
  managehome => true,  
}
/* Add user to passwordless /etc/sudoers */
exec { "echo \"${qs_user} ALL=(ALL) NOPASSWD: ALL\" | sudo tee -a /etc/sudoers > /dev/null":
  unless => ["sudo grep \"^${qs_user}\" /etc/sudoers"],
  require => User["quickstart"],
}

/* Create quickstart configuration code directory */

/* Clone read-only repo for further configuration */
exec { "quickstart-configure repo": 
  command => "git clone git://github.com/quickstart/quickstart-configure.git /var/quickstart/quickstart-configure",
  require => Package[[git]],
  unless => "test -d /var/quickstart/quickstart-configure",
}

exec { "save config": 
  command => "mkdir -p /var/quickstart; \
echo \"QS_VERSION=\"$QS_VERSION\"\" >> /var/quickstart/config.sh; \
echo \"QS_USER=\"$QS_USER\"\" >> /var/quickstart/config.sh; \
echo \"QS_HOSTNAME=\"$QS_HOSTNAME\"\" >> /var/quickstart/config.sh; \
echo \"QS_DESKTOPS=\"$QS_DESKTOPS\"\" >> /var/quickstart/config.sh; \
echo \"QS_PROJECTS=\"$QS_PROJECTS\"\" >> /var/quickstart/config.sh; \
chmod 644 /var/quickstart/config.sh",
  unless => "test -f /var/quickstart/config.sh",
}

