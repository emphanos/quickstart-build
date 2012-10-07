# This file is responsible for configuring the virtual hardware.

Vagrant::Config.run do |config|
  # Build with ./QuickBox/rebuild.sh
  config.vm.box = "QuickBox"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # Leave this :gui for QuickDev
  config.vm.boot_mode = :gui

  # Configure VM
  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--vram", 64]
  config.vm.customize ["modifyvm", :id, "--accelerate3d", "on"]
  config.vm.host_name = "qs-working-copy"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 80, 8080

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    # Execution continues in this file.
    puppet.manifest_file  = "build/QuickBase.pp"
  end

end
