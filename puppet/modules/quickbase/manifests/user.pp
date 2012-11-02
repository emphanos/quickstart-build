class quickbase::user {

	/* configure the "quickstart" user  */
	user { "quickstart":
	  name      => $QS_USER,
	  ensure    => present,
	  password  => $QS_USER,
	  groups    => ["www-data", "root", "admin"],
	  managehome => true,  
	}
	/* Add user to passwordless /etc/sudoers */
	exec { "echo \"${QS_USER} ALL=(ALL) NOPASSWD: ALL\" | sudo tee -a /etc/sudoers > /dev/null":
	  unless => ["sudo grep \"^${QS_USER}\" /etc/sudoers"],
	  require => User["quickstart"],
	}

} 
