# Phalcon Box

Phalcon strives to get closer to developers, providing flexible, powerful and simple tools.
We would like a Phalcon development process to be effortless and pleasant from deployment of the development environment
to the programming in [Zephir](https://github.com/phalcon/zephir) language.

----------

Phalcon Box is an official, pre-packaged Vagrant box that provides you a wonderful development environment without
requiring you to install PHP, a web server, and any other server software on your local machine.

[Vagrant](http://vagrantup.com/) provides a simple, elegant way to manage and provision Virtual Machines and this is a
_recommended_ Vagrant setup to get loaded with core development tools to build a powerful PHP application focused on
[Phalcon Framework](https://phalconphp.com/).

[Join us on Slack](https://slack.phalconphp.com/) to chat with other Phalcon contributors!

## Contents

- [Overview](#overview)
  - [Requirements](#requirements)
  - [Packages Included](#packages-included)
- [Install](#install)
  - [Installing the Vagrant Box](#installing-the-vagrant-box)
  - [Installing the Phalcon Box](#installing-the-phalcon-box)
  - [Configuring](#configuring)
    - [Memory and CPU](#memory-and-cpu)
    - [Shared folders](#shared-folders)
    - [Nginx sites](#nginx-sites)
    - [Configuring the `hosts` file](#configuring-the-hosts-file)
  - [Launching the Phalcon Box](#launching-the-phalcon-box)
- [Daily usage](#daily-usage)
  - [Accessing Phalcon Box globally](#accessing-phalcon-box-globally)
  - [Connecting via SSH](#connecting-via-ssh)
  - [Connecting to databases](#connecting-to-databases)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Overview

We use the default Phalcon xenial64 ISO from [Vagrant Cloud](https://atlas.hashicorp.com/phalconphp/boxes/xenial64/)
for compatibility. If you choose to use a 64-bit ISO you may need to update your BIOS to enable
[virtualization](https://en.wikipedia.org/wiki/X86_virtualization) with `AMD-V`, `Intel VT-x` or `VIA VT`.

When you provision Vagrant for the first time it's always the longest procedure (`vagrant up`). Vagrant will download
the entire Linux OS if you've never used Vagrant or the `phalconphp/xenial64` Box. Afterwards, booting time is fast.

### Requirements

* Operating System: Windows, Linux, or OSX
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads) >= 5.1
* [Vagrant](https://www.vagrantup.com/downloads.html) >= 1.9

### Packages Included

* Ubuntu 16.04
* Git
* PHP 7.1
* Nginx
* MySQL
* Sqlite3
* PostgreSQL
* Composer
* Phalcon
* Phalcon DevTools
* Redis
* Memcached
* Beanstalkd
* Zephir
* MongoDB

## Install

### Installing the Vagrant Box

Once VirtualBox and Vagrant have been installed, you should add the `phalconphp/xenial64` box to your Vagrant
installation using the following command in your terminal. It will take a few minutes to download the box, depending
on your Internet connection speed:

```bash
vagrant box add phalconphp/xenial64
```

If this command fails, make sure your Vagrant installation is up to date.

### Installing the Phalcon Box

You may install Phalcon Box by simply cloning the repository. Consider cloning the repository into a `workspace`
folder within your "home" directory, as the Phalcon Box box will serve as the host to all of your Phalcon projects:

```bash
cd ~
git clone https://github.com/phalcon/box.git workspace
```

The `master` branch will always contain the latest stable version of Phalcon Box. If you wish to check older versions
or newer ones currently under development, please switch to the relevant branch/tag.

You can find the latest stable version on the [Github Release Page](https://github.com/phalcon/box/releases):

```bash
# Clone the desired release...
git checkout v2.0.0
```

Once you have cloned the Phalcon Box repository, run the install command from the Phalcon Box root directory to
create the `settings.yml` configuration file. The `settings.yml` file will be placed in the Phalcon Box directory:

```bash
# macOS || Linux
bash install
```

```cmd
rem Windows
install.bat
```

Now you are ready to provision your Virtual Machine, run:

```bash
vagrant up
```

### Configuring

#### Memory and CPU

By default this setup uses 2GB RAM. You can change this in `settings.yml` and simply run `vagrant reload`:

```yaml
memory: 4096
```

You can also use more than one core if you like, simply change this line in the same file:

```yaml
cpus: 2
```

#### Shared folders

The `folders` property of the `settings.yml` file lists all of the folders you wish to share with your
Phalcon Box environment. As files within these folders are changed, they will be kept in sync between your local
machine and the Phalcon Box environment. You may configure as many shared folders as necessary:

```yaml
folders:
    - map: ~/workspace
      to: /home/vagrant/workspace
```

To enable [NFS](https://www.vagrantup.com/docs/synced-folders/nfs.html), just add a simple flag to your synced folder
configuration:

```yaml
folders:
    - map: ~/workspace
      to: /home/vagrant/workspace
      type: "nfs"
```

You may also pass any options supported by Vagrant's
[Synced Folders](https://www.vagrantup.com/docs/synced-folders/basic_usage.html) by listing them under the `options` key:

```yaml
folders:
    - map: ~/workspace
      to: /home/vagrant/workspace
      type: "nfs"
      options:
            rsync__args: ["--verbose", "--archive", "--delete", "-zz"]
            rsync__exclude: ["node_modules"]
```

**NOTE:** macOS users probably will need to install `vagrant-bindfs` plugin to fix shared folder (NFS) permission issue:

```bash
vagrant plugin install vagrant-bindfs
```

#### Nginx sites

The `sites` property allows you to easily map a "domain" to a folder on your Phalcon Box environment. A sample site
configuration is included in the `settings.yml` file. You may add as many sites to your Phalcon Box environment as
necessary. Phalcon Box can serve as a convenient, virtualized environment for every Phalcon project you are working on:

```yaml
sites:
    - map: phalcon.local
      to:  /home/vagrant/workspace/phalcon/public
```

If you change the `sites` property after provisioning the Phalcon Box, you should re-run `vagrant reload --provision`
to update the Nginx configuration on the virtual machine.


#### Configuring the `hosts` file

You must add the "domains" for your Nginx sites to the hosts file on your machine. The hosts file will redirect requests
for your Phalcon sites into your Phalcon Box machine. On Mac and Linux, this file is located at `/etc/hosts`.
On Windows, it is located at `C:\Windows\System32\drivers\etc\hosts`. The lines you add to this file will look like the
following:

```
192.168.50.4  phalcon.local
```

Make sure the IP address listed is the one set in your `settings.yml` file. Once you have added the domain to your
`hosts` file and launched the Vagrant box you will be able to access the site via your web browser:

```
http://phalcon.local
```

**NOTE:** To have an ability automatically add new sites to the `hosts` file use `vagrant-hostsupdater` plugin:

```bash
vagrant plugin install vagrant-hostsupdater
```

### Launching the Phalcon Box

Once you have edited the `settings.yml` to your liking, run the `vagrant up` command from your Phalcon Box directory
(for example `$HOME/workspace`). Vagrant will boot the virtual machine and automatically configure your shared folders
and Nginx sites.

To destroy the machine, you may use the `vagrant destroy --force` command.

## Daily usage

### Accessing Phalcon Box globally

Sometimes you may want to `vagrant up` your Phalcon Box machine from anywhere on your filesystem. You can do this on
Mac or Linux systems by adding a [Bash function](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-8.html) to your Bash
profile. On Windows, you may accomplish this by adding a "batch" file to your `PATH`. These scripts will allow you
to run any Vagrant command from anywhere on your system and will automatically point that command to your Phalcon Box
installation:

**Mac || Linux**

```bash
function box()
{
    ( cd $HOME/workspace && vagrant $* )
}
```

**NOTE:** Make sure to tweak the `$HOME/workspace` path in the function to the location of your actual Phalcon Box
installation. Once the function is installed, you may run commands like `box up` or `box ssh` from anywhere on your
system.

**Windows**

Create a `box.bat` batch file anywhere on your machine with the following contents:

```cmd
@echo off

set cwd=%cd%
set box=C:\workspace

cd /d %box% && vagrant %*
cd /d %cwd%

set cwd=
set box=
```

**NOTE:** Make sure to tweak the example `C:\workspace` path in the script to the actual location of your Phalcon Box
installation. After creating the file, add the file location to your `PATH`. You may then run commands like
`box up` or `box ssh` from anywhere on your system.

### Connecting via SSH

You can SSH into your virtual machine by issuing the `vagrant ssh` terminal command from your Phalcon Box directory.

But, since you will probably need to SSH into your Phalcon Box machine frequently, consider adding the "function"
[described above](#accessing-phalcon-box-globally) to your host machine to quickly SSH into the Phalcon Box.

### Connecting to databases

To connect to your MySQL or Postgres database from your host machine's database client, you should connect to
`127.0.0.1` and port `33060` (MySQL) or `54320` (Postgres). The username and password for both databases is
`phalcon` / `secret`.

**NOTE:** You should only use these non-standard ports when connecting to the databases from your host machine.
You will use the default `3306` and `5432` ports in your Phalcon database configuration file since Phalcon is running
within the virtual machine.

## Troubleshooting

**Problem:**

> An error occurred in the underlying SSH library that Vagrant uses.
> The error message is shown below. In many cases, errors from this
> library are caused by ssh-agent issues. Try disabling your SSH
> agent or removing some keys and try again.
> If the problem persists, please report a bug to the net-ssh project.
> timeout during server version negotiating

**Solution:**

```bash
vagrant plugin install vagrant-vbguest
```

**Problem:**

> Vagrant was unable to mount VirtualBox shared folders. This is usually
  because the filesystem "vboxsf" is not available. This filesystem is
  made available via the VirtualBox Guest Additions and kernel module.
  Please verify that these guest additions are properly installed in the
  guest. This is not a bug in Vagrant and is usually caused by a faulty
  Vagrant box. For context, the command attempted was:
>
> mount -t vboxsf -o uid=900,gid=900 vagrant /vagrant

```bash
vagrant plugin install vagrant-vbguest
```

## License

Phalcon Box is open source software licensed under the New BSD License.
See the LICENSE.txt file for more. <br>
Copyright (c) 2011-2017, Phalcon Framework Team
