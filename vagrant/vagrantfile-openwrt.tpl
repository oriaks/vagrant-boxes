Vagrant.configure("2") do |config|
  config.ssh.shell = "/bin/ash -l"
  config.ssh.sudo_command = "%c"
  config.ssh.username = "root"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
end
