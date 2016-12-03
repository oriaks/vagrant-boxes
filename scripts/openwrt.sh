#!/bin/sh

IMG_URL='http://downloads.openwrt.org/chaos_calmer/15.05.1/x86/64/openwrt-15.05.1-x86-64-combined-ext4.img.gz'

curl -fLsS "${IMG_URL}" | gunzip | dd of=/dev/sda bs=1M

mount /dev/sda2 /mnt/custom

chroot /mnt/custom /bin/sh <<- 'EOF'
	uci add firewall rule
	uci set firewall.@rule[-1].src=wan
	uci set firewall.@rule[-1].target=ACCEPT
	uci set firewall.@rule[-1].proto=tcp
	uci set firewall.@rule[-1].dest_port=22
	uci set network.lan.ifname=eth1
	uci set network.wan.ifname=eth0
	uci set network.wan6.ifname=eth0
	uci commit
	mkdir -p /root/.ssh
	cat > /root/.ssh/authorized_keys <<- 'EOF1'
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF1
	chmod 0700 /root/.ssh
	chmod 0600 /root/.ssh/authorized_keys
	ln -sf /root/.ssh/authorized_keys /etc/dropbear/authorized_keys
EOF

umount /mnt/custom
