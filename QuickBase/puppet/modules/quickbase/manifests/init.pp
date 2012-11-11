/**
 * This should
 *  - Download and applying OS updates (most updates are pre-applied in the Vagrant Box QuickBox)
 *  - install basic tools: git, puppet, ruby-full, rubygems
 *  - Configure a "quickstart" user
 *  - Setup the /var/quickstart directory
 *  - Clone the configuration git repository /var/quickstart/quickstart-configure
 */ 
class quickbase( $username ) {

	/* Set defaults */
	Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }


	/* download and apply OS updates */
	exec {"update":
		command => "sudo apt-get -yq update; sudo apt-get -yq upgrade; sudo apt-get -yq autoremove",
	}


	/* install basic tools: git, puppet, ruby-full, rubygems */
	package { ['git', 'wget', 'curl']:
		ensure => installed,
		require => Exec[update],
	}


	/* To set password, these packages must already be installed.  Moved to QuickBox/Vagrantfile
	package { ['puppet', 'ruby-full', 'rubygems', 'augeas-tools', 'libaugeas-ruby']:
		ensure => installed,
		require => Exec[update],
	}
	package { "ruby-shadow":
	    provider => 'gem',
	    ensure => installed,
	    require => Package[[rubygems]],
	}
	*/


	/* configure the "quickstart" user  */
	/* $password = inline_template("<%= %x{mkpasswd -m sha-512 quickstart} %>")  this isn't working */
	user { "quickstart":
	  name      => $quickbase::username,
	  ensure    => present,
	  password  => '$6$/R5A1klh$PXoQZGbxseqCCBzCVpICxV3B9HhbItxVzpWoSltnaj4096PE34C4mO5Rs39aJ67eOHu87/6HeHYyrjOtNjlah1',
	  groups    => ["www-data", "root", "admin", "vagrant"],
	  managehome => true,
          shell   => "/bin/bash",
	  /* require => Package[ruby-shadow], */
	}
	/* Add user to passwordless sudo */
	exec { "sudoers.d":
          command => "echo \"${quickbase::username} ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/${quickbase::username}; chmod 440 /etc/sudoers.d/${quickbase::username}",
	  creates => "/etc/sudoers.d/${quickbase::username}",
	  require => User["quickstart"],
	}


	/* Create the quickstart working directory */
	file { "/var/quickstart":
	  ensure => "directory",
	  owner  => $quickbase::username,
	  group  => "www-data",
	  mode   => 770,
	  require=> User["quickstart"],
	}


	/* Clone read-only repo for further configuration */
	exec { "quickstart-configure repo": 
	  command => "git clone --recursive git://github.com/quickstart/quickstart-configure.git /var/quickstart/quickstart-configure",
	  require => [ User["quickstart"], Package[[git]] ],
	  user => $quickbase::username,
	  unless => "test -d /var/quickstart/quickstart-configure/.git",
	}

	
}
