# DSA Website Plumbing

This is the system-administration bit of the DSA website.
The WordPress site with the content comes from [another repo][wp-repo].

[wp-repo]: https://github.com/portland-dsa/portland-dsa-website

## Getting Started

This project uses [Vagrant][vagrant] to define a virtual machine that runs the website locally.
Before we get started, you should install these vagrant plugins:
  * vagrant-env
  * vagrant-digitalocean

You don't need a DigitalOcean account, but I'm not sure exactly what happens given that some of the boxes are statically defined to have that provider.

Now we're ready to bring up the box.
For some bizarre reason I couldn't find an Ubuntu 16.04 box with Puppet 4 installed that actually worked, so this does require some manual steps:

1. Run `vagrant up dev --no-provision` to bring the VM up.
2. Run `vagrant ssh dev` to log on to the VM.
3. Run `cd /vagrant` in the VM to switch to the VM's directory that mirrors this repo.
4. Run `./vagrant-init.sh` to add Puppet's package repository and install the puppet agent (this will take a few minutes, especially depending on your network speed).
5. Hit Ctrl-d (or run `logout`) to log out of the VM.
6. Run `vagrant provision dev` to run puppet and set everything up (this part will take about five minutes).

Once you've done all that, you'll be able to see your local copy of the DSA site by going to `192.168.42.13` in your web browser.

[Vagrant]: https://vagrantup.com
