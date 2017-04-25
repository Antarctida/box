# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Fixed
- Fixed the `slayer` Nginx configuration

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

[Unreleased]: https://github.com/phalcon/box/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/phalcon/box/compare/v2.1.0...v2.0.2
[2.0.2]: https://github.com/phalcon/box/compare/v2.0.2...v2.0.1
[2.0.1]: https://github.com/phalcon/box/compare/v2.0.1...v2.0.0
[2.0.0]: https://github.com/phalcon/box/compare/v2.0.0...v1.2.0
[1.2.0]: https://github.com/phalcon/box/compare/v1.2.0...v1.0.0
