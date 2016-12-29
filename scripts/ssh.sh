#!/bin/sh

if [ -f /etc/ssh/sshd_config ]; then

  if [ -f /private/etc/ssh/sshd_config ]; then
    # macOS specific
    sed -i '' -f /dev/stdin /etc/ssh/sshd_config <<-EOF
	s/^[#]*UseDNS[[:space:]]*.*/UseDNS no/;
	s/^[#]*PasswordAuthentication[[:space:]]*.*/PasswordAuthentication no/;
EOF
  else
    # Debian and RedHat specific
    sed -i -f- /etc/ssh/sshd_config <<-EOF
	s|^[#]*UseDNS[[:space:]]*.*|UseDNS no|;
	s|^[#]*PasswordAuthentication[[:space:]]*.*|PasswordAuthentication no|;
EOF
  fi

  if ! grep -q '^UseDNS no' /etc/ssh/sshd_config; then
    echo 'UseDNS no' >> /etc/ssh/sshd_config
  fi

  if ! grep -q '^PasswordAuthentication no' /etc/ssh/sshd_config; then
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
  fi

  # Debian specific
  if [ -f /etc/default/ssh ]; then
    sed -i -f- /etc/default/ssh <<-EOF
	s|^SSHD_OPTS=.*|SSHD_OPTS="-u0"|;
EOF
  fi

  # Red Hat specific
  if [ -f /etc/sysconfig/sshd ]; then
    sed -i -f- /etc/default/ssh <<-EOF
	s|^OPTIONS=.*|OPTIONS="-u0"|;
EOF
  fi
fi

exit 0
