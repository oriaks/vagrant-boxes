#!/bin/sh

# Prevent DNS resolution (speed up logins)
# Disable password logins
sed -i -f- /etc/ssh/sshd_config <<-EOF
	s|^[#]*UseDNS[[:space:]]*.*|UseDNS no|;
	s|^[#]*PasswordAuthentication[[:space:]]*.*|PasswordAuthentication no|;
EOF

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

exit 0
