#!/bin/sh

# Debian specific
if which apt-get; then
  apt-get autoremove -y --purge
  apt-get clean -y
  rm -rf /usr/sbin/policy-rc.d /var/lib/apt/lists/* /tmp/* /var/tmp/*
fi

# Red Hat specific
if which yum; then
  yum erase -y avahi bitstream-vera-fonts gtk2 hicolor-icon-theme libX11
  yum clean -y all
  rm -rf VBoxGuestAdditions_*.iso
  rm -rf /tmp/rubygems-*
fi

# Clean up extraneous files that may be left around
rm -f /etc/resolv.conf 
#rm -f /etc/ssh/ssh_host_*
rm -f /etc/*- 
rm -f /root/.vbox_version
rm -f /var/lib/dhcp/dhclient.*.leases
rm -f /var/lib/NetworkManager/dhclient-*.lease
sed -i '/^[^#]/d' /etc/chrony.keys

# Truncate instead of delete, LP: #707311
if [ -f /etc/popularity-contest.conf ]; then
  truncate --size=0 -c /etc/popularity-contest.conf
fi

exit 0
