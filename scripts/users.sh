#!/bin/sh

# Debian and RedHat specific
if which useradd; then
  useradd --uid 1000 --shell /bin/bash vagrant

  mkdir -p /home/vagrant/.ssh
  cat > /home/vagrant/.ssh/authorized_keys <<-EOF
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF
  chmod 0700 /home/vagrant/.ssh
  chmod 0600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant:vagrant /home/vagrant

  if [ -d /etc/sudoers.d ]; then
    cat > /etc/sudoers.d/vagrant <<-EOF
	Defaults !requiretty
	vagrant ALL=(ALL) NOPASSWD:ALL
EOF
    chmod 0440 /etc/sudoers.d/vagrant
  fi
fi

# macOS specific
if which dscl; then
  dscl . -create /Users/vagrant
  dscl . -create /Users/vagrant UserShell /bin/bash
  dscl . -create /Users/vagrant RealName 'Vagrant'
  dscl . -create /Users/vagrant UniqueID 501
  dscl . -create /Users/vagrant PrimaryGroupID 20
  dscl . -create /Users/vagrant NFSHomeDirectory /Users/vagrant
  dscl . -passwd /Users/vagrant vagrant
  dseditgroup -o edit -t user -a vagrant admin
  createhomedir -c

  mkdir -p /Users/vagrant/.ssh
  cat > /Users/vagrant/.ssh/authorized_keys <<-EOF
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF
  chmod 0700 /Users/vagrant/.ssh
  chmod 0600 /Users/vagrant/.ssh/authorized_keys
  chown -R vagrant:staff /Users/vagrant

  if [ -d /etc/sudoers.d ]; then
    cat > /etc/sudoers.d/vagrant <<-EOF
	Defaults !requiretty
	vagrant ALL=(ALL) NOPASSWD:ALL
EOF
    chmod 0440 /etc/sudoers.d/vagrant
  fi
fi

exit 0
