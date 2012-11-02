class quickbase::gitrepo {

	/* Create quickstart configuration code directory */
	file { "/var/quickstart/quickstart-configure":
	  ensure => "directory",
	  owner  => $QS_USER,
	  group  => "www-data",
	  mode   => 770,
	  require=> File["/var/quickstart"],
	}

	/* Clone read-only repo for further configuration */
	exec { "quickstart-configure repo": 
	  command => "su ${QS_USER} -c \"git clone git://github.com/quickstart/quickstart-configure.git /var/quickstart/quickstart-configure\"",
	  require => [ User["quickstart"], Package[[git]], ],
	  unless => "test -d /var/quickstart/quickstart-configure/.git",
	}

}
