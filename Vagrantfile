# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "dev" do |config|
    config.vm.box = "ubuntu/xenial64"

    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    config.vm.network "private_network", ip: "192.168.42.13"
    config.vm.network "forwarded_port", guest: 80, host: 8989

    config.vm.provision :puppet, :options => ["--trace", "--verbose"] do |puppet|
      puppet.environment_path = "puppet/environments"
      puppet.environment = "production"
    end

    config.vm.synced_folder "./data", "/vagrant_data"
  end
end
