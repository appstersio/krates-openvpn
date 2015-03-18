# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Setup btrfs for Docker since the AUFS is kind-of broken :)

provision_script = <<SCRIPT
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y -q lxc-docker python-pip
sudo pip install docker-compose
sudo gpasswd -a vagrant docker
sudo wget -O /usr/local/bin/weave \
  https://github.com/zettio/weave/releases/download/latest_release/weave
sudo chmod a+x /usr/local/bin/weave
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "docker" do |docker|
    docker.vm.box = "ubuntu/trusty64"
    docker.vm.network "private_network", ip: "192.168.33.103"
    docker.vm.hostname = "docker-openvpn"
    docker.vm.provider "virtualbox" do |vb|
      # Don't boot with headless mode
      vb.gui = false
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    docker.vm.provision "shell", inline: provision_script
  end
    
end
