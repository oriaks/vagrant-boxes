#!/bin/vbash

if [ `whoami` == 'root' ]; then
  sudo -u vagrant $0 "$@"
  exit 0
fi

source /opt/vyatta/etc/functions/script-template

configure

delete interfaces ethernet eth0 hw-id
delete system login user vagrant authentication encrypted-password
delete system login user vagrant authentication plaintext-password

set service ssh disable-host-validation 
set service ssh disable-password-authentication 

set system login user vagrant authentication public-keys insecure type "ssh-rsa"
set system login user vagrant authentication public-keys insecure key "AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ=="

set system time-zone America/Toronto

commit
save
exit
