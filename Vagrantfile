# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-12"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "4"
    vb.memory = "4096"
  end
  config.vm.provision "shell", inline: <<-SHELL
    apt-get -y install git
  SHELL
  config.vm.provision "shell", privileged: false, inline: <<-UNPRIVSHELL
    git clone https://github.com/mikerenfro/icpc-livecd.git
    cd icpc-livecd
    sudo ./build.sh
    sudo mv -v /root/icpc/live-image-amd64.hybrid.iso \
      /vagrant/icpc-livecd-without-internet-amd64.hybrid.iso
    sudo rm -rf /root/icpc/
    sudo ./build.sh allow-internet
    mv -v /root/icpc/live-image-amd64.hybrid.iso \
      /vagrant/icpc-livecd-with-internet-amd64.hybrid.iso
  UNPRIVSHELL
end
