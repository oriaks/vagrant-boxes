# oriaks/vagrant-boxes

These are Packer templates to build our base images for Vagrant/VirtualBox at Oriaks.

## Requirements

- [Packer](https://packer.io/)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## How to use

```console
git clone https://github.com/oriaks/vagrant-boxes.git
cd vagrant-boxes
make ONLY=virtualbox-iso debian-8-amd64
vagrant box add --name debian-8-amd64 debian-8-amd64-virtualbox.box
```

## ToDo

- Add libvirt builders
- Add cloud-init package

## See also

- [debian-vm-templates](https://anonscm.debian.org/git/cloud/debian-vm-templates.git/)
- [packer-templates](https://github.com/shiguredo/packer-templates/)
- [packer-windows](https://github.com/joefitzgerald/packer-windows/)
