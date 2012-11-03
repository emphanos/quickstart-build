/**
 * This should
 *  - Download and applying OS updates (most updates are pre-applied in the Vagrant Box QuickBox)
 *  - install basic tools: git, puppet, ruby-full, rubygems
 *  - Configure a "quickstart" user
 *  - Setup the /var/quickstart directory
 *  - Clone the configuration git repository /var/quickstart/quickstart-configure
 */ 
class quickbase( $username ) {

	Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

	/* include quickbase::update   FIXME taking this out to speed up development */
	include quickbase::tools
	include quickbase::user
	include quickbase::workingdir
	include quickbase::gitrepo
	
}
