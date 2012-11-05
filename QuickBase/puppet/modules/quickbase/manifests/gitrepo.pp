class quickbase::gitrepo {

	/* Create quickstart configuration code directory */
	/* FIXME is this actually needed? */
	file { "/var/quickstart/quickstart-configure":
	  ensure => "directory",
	  owner  => $quickbase::username,
	  group  => "www-data",
	  mode   => 770,
	  require=> File["/var/quickstart"],
	}

	/* Clone read-only repo for further configuration */
	exec { "quickstart-configure repo": 
	  command => "git clone --recursive git://github.com/quickstart/quickstart-configure.git /var/quickstart/quickstart-configure",
	  require => [ User["quickstart"], Package[[git]], File["/var/quickstart/quickstart-configure"] ],
	  user => $quickbase::username,
	  unless => "test -d /var/quickstart/quickstart-configure/.git",
	}

}
