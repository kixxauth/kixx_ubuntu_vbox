Bare Bones Ubuntu Vagrant VirtualBox
====================================
A simple, bare bones Vagrant box with a few minimal things installed to get running
easier than the default vagrant Ubuntu boxes.

Here's what's included:

* `apt-get update && apt-get dist-upgrade` are run.
* build-essential, git-core, and dkms packages are installed with apt-get.
* VirtualBox Guest Additions are installed.

Updating, Building, and Packaging the Box
-----------------------------------------

### 1) Install VirtualBox and Vagrant
Update to the latest [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
followed by [Vagrant](https://www.virtualbox.org/wiki/Downloads).

When building for Vagrant, for the rest of these steps, make sure your current
working directory is the root directory for the guest VM on your local host
machine. When building a base box this should always the root directory of
this repository (where the Vagrantfile and README files live).

The next thing you'll need is the VirtualBox Guest Additions. This was actually
already downloaded when you installed VirtualBox, but we need to copy the
VBoxGuestAdditions.iso to the VM root directory (the root of this repository)
on your local machine so it is available in the `/vagrant/` shared folder from
within the VM.  This will allow us to mount the iso image and install
VBoxGuestAdditions.  Copy the image from one of these locations:

* On Mac OS X hosts, you can find this file in the application bundle of VirtualBox `/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso`.
* On an Ubuntu host, you can find this file at `/usr/share/virtualbox/VBoxGuestAdditions.iso`.


### 2) Prep the System
First you need to start the VM.

	vagrant up

Make a note of the local IP address that it reports on the terminal. You'll
need that for the next step.

Once the VM is up, log into the box with

	vagrant ssh

Once you're in, move the VBoxGuestAdditions.iso to a new location so you don't
lose it:

	mv /vagrant/VBoxGuestAdditions.iso ~/

and move into the shared vagrant folder with

	cd /vagrant

Once there, run the setup script with

	./setup.sh

This will update the Ubuntu packages and install some dependencies for us.
This script will take several minutes to run, and while it does, you might be
prompted to answer a question or two about the install. Just use the default
choices and continue on. Once it's done, exit the ssh session.


### 3) Install VBox Guest Additions
After exiting the VM, restart it with `vagrant reload`. You'll notice that
vagrant seems to break at this point. That's because we've updated the Ubuntu
system, but we have not yet updated VBoxGuestAdditions. So, when the machine
restarts you'll see this:

	The following SSH command responded with a non-zero exit status.
	Vagrant assumes that this means the command failed!

	mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` v-root /vagrant

Not to worry, we're going to fix that right now. SSH back into the VM with
`vagrant ssh` and mount the iso image:

	cd ~
	mkdir vbg
	sudo mount -o loop ~/VBoxGuestAdditions.iso ~/vbg

And then install VBoxGuestAdditions:

	sudo vbg/VBoxLinuxAdditions.run

It will warn you that it could not find the Window System drivers, but that's
OK, because we don't use them.  After it's done, let's remove the iso image:

	sudo umount ~/vbg
	rm ~/VBoxGuestAdditions.iso
	rmdir ~/vbg


### 5) Package the Box
First test the web servers with:

Then packaging the box is pretty simple:

	vagrant package -o /tmp/jfdi-YYYY-MM-DD.box

Run that command from within the `virtual_machines/devbox/` directory.
When it's done packaging the box, upload it to Amazon S3.
