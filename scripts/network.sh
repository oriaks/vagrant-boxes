#!/bin/sh

# Fix for https://github.com/CentOS/sig-cloud-instance-build/issues/38
if [ -d /etc/sysconfig/network-scripts ]; then
  cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	DEVICE="eth0"
	BOOTPROTO="dhcp"
	ONBOOT="yes"
	TYPE="Ethernet"
	PERSISTENT_DHCLIENT="yes"
EOF
fi

exit 0
