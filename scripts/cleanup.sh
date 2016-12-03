#!/bin/sh

# Debian specific
if which apt-get; then
  apt-get purge -y anacron avahi-autoipd discover installation-report laptop-detect libio-socket-ip-perl libpcsclite1 pinentry-gtk2 task-laptop
  apt-get autoremove -y --purge
  apt-get clean -y
  rm -rf /usr/sbin/policy-rc.d /var/lib/apt/lists/* /tmp/* /var/tmp/*
fi

# Red Hat specific
if which yum; then
  package-cleanup -y --oldkernels --count=1
  if [ `yum list installed | grep kernel.$(uname -p) | wc -l` -gt 1 ]; then
    rpm -e "kernel-$(uname -r)"
  fi
  yum clean -y all
  rm -rf /tmp/rubygems-* /var/cache/yum/*
fi

# Clean up extraneous files that may be left around
find /etc/resolv.conf -type f | xargs rm -f
#rm -f /etc/ssh/ssh_host_*
rm -f /etc/*- 
rm -f /root/.vbox_version
rm -f /run/resolvconf/resolv.conf
rm -rf /tmp/*
rm -f /var/lib/dhcp/dhclient.*.leases
rm -f /var/lib/NetworkManager/dhclient-*.lease

# Truncate instead of delete, LP: #707311
if [ -f /etc/popularity-contest.conf ]; then
  truncate --size=0 -c /etc/popularity-contest.conf
fi

exit 0
