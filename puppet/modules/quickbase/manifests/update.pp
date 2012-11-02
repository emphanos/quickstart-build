class quickbase::update {

	/* download and apply OS updates */
	exec {"sudo apt-get -yq update; sudo apt-get -yq upgrade; sudo apt-get -yq autoremove":}

}

