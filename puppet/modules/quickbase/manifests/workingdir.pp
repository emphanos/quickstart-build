class quickbase::workingdir {

	file { "/var/quickstart":
	  ensure => "directory",
	  owner  => $QS_USER,
	  group  => "www-data",
	  mode   => 770,
	  require=> User["quickstart"],
	}

}
