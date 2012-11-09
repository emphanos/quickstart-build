class quickbase::user {

	/* configure the "quickstart" user  */

	/* FIXME */
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

} 
