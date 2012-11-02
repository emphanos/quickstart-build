class project {

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
	exec { "echo \"$qs_user ALL=(ALL) NOPASSWD: ALL\" | sudo tee -a /etc/sudoers > /dev/null":
	  unless => ["sudo grep \"^$qs_user\" /etc/sudoers"],
	  require => User["quickstart"],
	}

	/* Create quickstart configuration code directory */

	/* Clone read-only repo for further configuration */
	exec { "quickstart-configure repo": 
	  command => "echo $qs_user; su $qs_user -c git clone git://github.com/quickstart/quickstart-configure.git /var/quickstart/quickstart-configure",
	  require => [ User["quickstart"], Package[[git]], ],
	  unless => "test -d /var/quickstart/quickstart-configure",
	}

	file { "/var/quickstart":
	  ensure => "directory",
	  owner  => $qs_user,
	  group  => "www-data",
	  mode   => 770,
	}
	exec { "save config": 
	  command => "set > set.txt",
	  unless => "test -f /var/quickstart/set.txt",
	}
}
