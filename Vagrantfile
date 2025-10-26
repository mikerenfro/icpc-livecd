# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-13"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "4"
    vb.memory = "4096"
  end
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get -y install git
  SHELL
  config.vm.provision "shell", privileged: false, inline: <<-UNPRIVSHELL
    git clone https://github.com/mikerenfro/icpc-livecd.git
    cd icpc-livecd
    git checkout 2025
    ./build.sh
    mv -v ~/icpc-livecd-without-internet-amd64.hybrid.iso \
      /vagrant/
    sudo rm -rf ~/icpc/
    ./build.sh allow-internet
    mv -v ~/icpc-livecd-with-internet-amd64.hybrid.iso \
      /vagrant/
  UNPRIVSHELL
end
