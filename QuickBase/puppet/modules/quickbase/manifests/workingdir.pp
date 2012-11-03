class quickbase::workingdir {

	file { "/var/quickstart":
	  ensure => "directory",
	  owner  => $quickbase::username,
	  group  => "www-data",
	  mode   => 770,
	  require=> User["quickstart"],
	}

}
