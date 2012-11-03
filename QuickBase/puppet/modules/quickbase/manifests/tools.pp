class quickbase::tools {

	/* install basic tools: git, puppet, ruby-full, rubygems */
	package { ['git', 'puppet', 'ruby-full', 'rubygems']:
		ensure => installed,
	}
	package { "ruby-shadow":
	    provider => 'gem',
	    ensure => installed,
	    require => Package[[rubygems]],
	}

}
