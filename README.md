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
- [Install](#overview)

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

### Install

**Installing The Vagrant Box**

Once VirtualBox / VMware and Vagrant have been installed, you should add the `phalconphp/xenial64` box to your Vagrant
installation using the following command in your terminal. It will take a few minutes to download the box, depending
on your Internet connection speed:

```bash
vagrant box add phalconphp/xenial64
```

If this command fails, make sure your Vagrant installation is up to date.

**Installing The Phalcon Box**

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

Once you have cloned the Phalcon Box repository, run the `bash install` command from the Phalcon Box directory to
create the `settings.yml` configuration file. The `settings.yml` file will be placed in the Phalcon Box directory:

```bash
# macOS || Linux
bash install
```

```cmd
rem Windows
install.bat
```

## License

Phalcon Box is open source software licensed under the New BSD License.
See the LICENSE.txt file for more. <br>
Copyright (c) 2011-2017, Phalcon Framework Team
