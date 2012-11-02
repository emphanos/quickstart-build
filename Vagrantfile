# This file is responsible for configuring the virtual hardware.

Vagrant::Config.run do |config|

  # This "box" can be built with ./QuickBox/rebuild.sh
  config.vm.box = "QuickBox"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # Leave this :gui for QuickDev
  #config.vm.boot_mode = :gui

  # Configure VM Hardware
  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--vram", 64]
  config.vm.customize ["modifyvm", :id, "--accelerate3d", "on"]

  # Configure VM OS
  config.vm.host_name = "qs-working-copy"

  # Configure VM Network
  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 80, 8080

  # Configure VM Shared folders
  config.vm.share_folder "Shared", "/var/quickstart/shared", "~/Desktop/shared"

  # Configure Image Development shared folder.
  # Rather than commiting to git each change, share quickstart-configure.  See build-settings.sh ~line 25
  # Comment this line for "official build"
  config.vm.share_folder "Shared", "/tmp/quickstart-configure", "~/quickstart-configure"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    # Execution continues in this file.
    puppet.manifest_file  = "build/QuickBase.pp"
    puppet.options = [
      '--verbose',
#      '--debug',
    ]
  end

end
