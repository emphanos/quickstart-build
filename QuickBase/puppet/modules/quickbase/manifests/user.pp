class quickbase::user {

	/* configure the "quickstart" user  */
	user { "quickstart":
	  name      => $quickbase::username,
	  ensure    => present,
	  password  => $quickbase::username,
	  groups    => ["www-data", "root", "admin"],
	  managehome => true,
          shell   => "/bin/bash",
	}

	/* Add user to passwordless sudo */
	exec { "sudoers.d":
          command => "echo \"${quickbase::username} ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/${quickbase::username}; chmod 440 /etc/sudoers.d/${quickbase::username}",
	  creates => "/etc/sudoers.d/${quickbase::username}",
	  require => User["quickstart"],
	}

} 
