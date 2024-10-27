# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "4"
    vb.memory = "4096"
  end
  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant
    ./build.sh
    mv -v ~/icpc/live-image-amd64.hybrid.iso \
      /vagrant/icpc-livecd-without-internet-amd64.hybrid.iso
    rm -rf ~/icpc/
    ./build.sh allow-internet
    mv -v ~/icpc/live-image-amd64.hybrid.iso \
      /vagrant/icpc-livecd-with-internet-amd64.hybrid.iso
  SHELL
end
