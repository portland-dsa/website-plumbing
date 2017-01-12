#! /bin/sh

cd ~ && wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i puppetlabs-release-pc1-trusty.deb

sudo apt-get update
sudo apt-get remove puppet
sudo apt-get install puppet-agent
