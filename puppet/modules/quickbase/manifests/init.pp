/**
 * This should
 *  - Download and applying OS updates (most updates are pre-applied in the Vagrant Box QuickBox)
 *  - install basic tools: git, puppet, ruby-full, rubygems
 *  - Configure a "quickstart" user
 *  - Setup the /var/quickstart directory
 *  - Clone the configuration git repository /var/quickstart/quickstart-configure
 */ 
class quickbase {

	include quickbase::update
	include quickbase::tools
	include quickbase::user
	include quickbase::workingdir
	include quickbase::gitrepo
	
}
