class quickbase::tools {

	/* install basic tools: git, puppet, ruby-full, rubygems */

	/* due to problem with setting password, these packages are installed in quickbox.  See QuickBox/Vagrantfile
	package { ['git', 'puppet', 'ruby-full', 'rubygems']:
		ensure => installed,
	}
	package { "ruby-shadow":
	    provider => 'gem',
	    ensure => installed,
	    require => Package[[rubygems]],
	}
	*/
}
