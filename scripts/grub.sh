#!/bin/sh

sed -i -f- /etc/default/grub <<-EOF
	s|^GRUB_TIMEOUT=.*|GRUB_TIMEOUT=1|;
	s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="biosdevname=0 console=tty1 console=ttyS0 net.ifnames=0 no_timer_check"|;
	s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="biosdevname=0 console=tty1 console=ttyS0 net.ifnames=0 no_timer_check"|;
EOF

# Debian specific
if which update-grub; then
  update-grub
fi

# Red Hat specific
if which grub2-mkconfig; then
  grub2-mkconfig -o /boot/grub2/grub.cfg
fi

exit 0
