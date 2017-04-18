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
- [Install](#install)
- [Packages Included](#packages-included)
- [Troubleshooting](#troubleshooting)
- [License](#license)

### Overview

We use the default Phalcon xenial64 ISO from [Vagrant Cloud](https://atlas.hashicorp.com/phalconphp/boxes/xenial64/)
for compatibility. If you choose to use a 64-bit ISO you may need to update your BIOS to enable
[virtualization](https://en.wikipedia.org/wiki/X86_virtualization) with `AMD-V`, `Intel VT-x` or `VIA VT`.

When you provision Vagrant for the first time it's always the longest procedure (`vagrant up`). Vagrant will download
the entire Linux OS if you've never used Vagrant or the `phalconphp/xenial64` Box. Afterwards, booting time is fast.

By default this setup uses 2 GB. You can change this in `settings.yml` and simply run `vagrant reload`.
You can also use more than one core if you like, simply change this line in the same file:

```yaml
cpus: 1
```

### Requirements

* Operating System: Windows, Linux, or OSX
* Virtualbox >= 5.0
* Vagrant >= 1.9

### Install

**Installing the Vagrant Box**

Once VirtualBox and Vagrant have been installed, you should add the `phalconphp/xenial64` box to your Vagrant
installation using the following command in your terminal. It will take a few minutes to download the box, depending
on your Internet connection speed:

```bash
vagrant box add phalconphp/xenial64
```

If this command fails, make sure your Vagrant installation is up to date.

**Installing the Phalcon Box**

You may install Phalcon Box by simply cloning the repository. Consider cloning the repository into a `workspace`
folder within your "home" directory, as the Phalcon Box box will serve as the host to all of your Phalcon projects:

```bash
cd ~
git clone https://github.com/phalcon/box.git workspace
```

You should check out a tagged version of Phalcon Box since the `master` branch may not always be stable.
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

## Packages Included

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

## Troubleshooting

Problem:

> An error occurred in the underlying SSH library that Vagrant uses.
  The error message is shown below. In many cases, errors from this
  library are caused by ssh-agent issues. Try disabling your SSH
  agent or removing some keys and try again.
  If the problem persists, please report a bug to the net-ssh project.
  timeout during server version negotiating

Solution:

```bash
vagrant plugin install vagrant-vbguest
```

## License

Phalcon Box is open source software licensed under the New BSD License.
See the LICENSE.txt file for more. <br>
Copyright (c) 2011-2017, Phalcon Framework Team
