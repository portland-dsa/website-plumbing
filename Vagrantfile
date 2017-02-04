# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "production" do |config|
    config.vm.provider :digital_ocean do |provider, override|
      override.ssh.private_key_path = '~/.ssh/id_rsa'
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      provider.token = 'fbac6d52a496363d6362104f43f6689a7aa8efd7705c029466b909478805d386'
      provider.image = 'ubuntu-16-04-x64'
      provider.region = 'sfo2'
      provider.size = '512mb'
      provider.ssh_key_name = 'dlp@kasei'
    end

    config.vm.provision :puppet, :options => ["--trace", "--verbose"] do |puppet|
      puppet.environment_path = "puppet/environments"
      puppet.environment = "production"
    end

    config.vm.synced_folder "data", "/vagrant", type: "rsync"
  end

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
