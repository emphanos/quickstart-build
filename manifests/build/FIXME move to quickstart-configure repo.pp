/* some leftover code that should be in the puppet config repo */

/* Configure automatic updates */
file { '/etc/apt/apt.conf.d/10periodic':
  content => "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
"
}


