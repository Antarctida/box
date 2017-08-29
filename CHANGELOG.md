# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [2.5.1] - 2017-08-30
### Changed
- Phalcon Box now require Vagrant >= 1.9.8 [#87](https://github.com/phalcon/box/issues/87)
- Update message of the day

## [2.5.0] - 2017-05-27
### Added
- Added ability to use per site environment variables by introducing `variables` section

## [2.4.0] - 2017-05-10
### Added
- Added ability to install custom packages through provisioning [#77](https://github.com/phalcon/box/issues/77)

### Fixed
- Fixed `memory` setting on `auto` mode

## [2.3.0] - 2017-05-05
### Added
- Added `zend` Nginx configuration
- Initial support of VMWare
- Introducing provisioning by Ansible
- Introducing testing on Travis CI
- Added ability to use custom provision by playing with `after_provision.sh` file

### Changed
- Reactored `blackfire` configuration (`client-id` => `client_id` `client-token` => `client_token`) to follow pure YAML
- Moved `resources` to the common place
- CS fixes nad cleanup
- Bump minimal Vagrant Box version. See [Maker changes](https://github.com/phalcon/maker/releases/tag/v2.0.3)

## [2.2.2] - 2017-05-02
### Changed
- Bump minimal Vagrant Box version. See [Maker changes](https://github.com/phalcon/maker/releases/tag/v2.0.2)

## [2.2.1] - 2017-05-02
### Changed
- Bump minimal Vagrant Box version. See [Maker changes](https://github.com/phalcon/maker/releases/tag/v2.0.1) 

### Added
- Added ability to export custom databases by using `myexport $FILE "db1 db2 db3"`

## [2.2.0] - 2017-05-01
### Added
- Added ability to import custom database by using `myimport $FILE $DBNAME`
- Added `phanbook` Nginx configuration
- Added `clear_logs` bash alias to cleanup **all** log files from `/var/log`

### Changed
- Refactor MySQL provision
- Improved MySQL configuration (`.my.cnf`)
- Changed default VM name from `box` to `pbox`
- Bump minimal Vagrant Box version

### Fixed
- Fixed the `slayer` Nginx configuration
- Fixed Message of the Day
- Fixed shebag line for scripts
- Fixed dotfiles ownership

## [2.1.0] - 2017-04-25
### Added
- Added ability to specify the type of Nginx configuration for the site [#67](https://github.com/phalcon/box/issues/67)

## [2.0.2] - 2017-04-25
### Added
- Configure Message of the Day
- Added ability to setting up Blackfire agent and client
- Code cleanup

### Changed
- Improved setting and cleaning environment variables
- Bump minimal Vagrant Box version

## [2.0.1] - 2017-04-24
### Added
- Added ability to create databases at MongoDB
- Added `.mongorc.js` dotfile

### Changed
- Make `Phalcon::init` and `Phalcon::show_banner` public
- Improved reporting of problems with mounting host folder
- Improved creating SSL certificate
- Code cleanup

### Fixed
- Fixed `Authorize::configure` to correctly configure the public key for SSH access

## [2.0.0] - 2017-04-24
### Added
- Added [Ansible](https://www.ansible.com)
- Added [Mailhog](https://github.com/mailhog/MailHog)
- Added [MongoDB](https://www.mongodb.com)
- Added [Ngrok](https://ngrok.com)
- Added [Node.js](https://nodejs.org/en/) (with [Yarn](https://yarnpkg.com/en/), [Bower](https://bower.io), [Grunt](https://gruntjs.com), and [Gulp](http://gulpjs.com))
- Added [PHIVE](https://phar.io)
- Added [PHPMD](https://phpmd.org)
- Added [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- Added [Phing](https://www.phing.info)
- Added [goreplace](https://github.com/webdevops/go-replace)
- Added [Blackfire](https://blackfire.io)
- Added a lot of PHP extensions
- Added ability to customize VM
- Added ability to create Databases on the fly
- Added ability to create Virtual Hosts on the fly
- Added GNU Readline configuration
- Added Generic Colouriser configuration

### Changed
- Fully refactored project in Ruby
- The PHP version changed to 7.1
- The MySQL version changed to 5.7
- The Postgres version changed to 9.5
- Used new box `phalcon/xenial64` box from [Vagrant Cloud](https://atlas.hashicorp.com/phalconphp/boxes/xenial64/)
- Updated documentation
- Virtual Machine now use Nginx

### Fixed
- Fixed Phalcon installation [#37](https://github.com/phalcon/box/issues/37)
- Fixed permissions issues [#55](https://github.com/phalcon/box/issues/55), [#60](https://github.com/phalcon/box/issues/60)

## [1.2.0] - 2017-03-22
### Changed
- Updated Phalcon & Zephir

## 1.0.0 - 2016-10-08
### Added
- Initial stable release

[Unreleased]: https://github.com/phalcon/box/compare/v2.5.1...development
[2.5.1]: https://github.com/phalcon/box/compare/v2.5.0...v2.5.1
[2.5.0]: https://github.com/phalcon/box/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/phalcon/box/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/phalcon/box/compare/v2.2.2...v2.3.0
[2.2.2]: https://github.com/phalcon/box/compare/v2.2.1...v2.2.2
[2.2.1]: https://github.com/phalcon/box/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/phalcon/box/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/phalcon/box/compare/v2.0.2...v2.1.0
[2.0.2]: https://github.com/phalcon/box/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/phalcon/box/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/phalcon/box/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/phalcon/box/compare/v1.0.0...v1.2.0
