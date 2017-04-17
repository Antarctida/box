# -*- mode: ruby -*-
# vi: set ft=ruby :

path = File.dirname(__FILE__).to_s

require 'json'
require 'yaml'
require File.expand_path(path + '/src/phalcon.rb')

VAGRANTFILE_API_VERSION ||= 2

Phalcon.application_root = File.dirname(__FILE__).to_s
Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  settings = {}
  if File.exist?(path + '/settings.yml')
    settings = YAML.safe_load(File.read(path + '/settings.yml'))
  end

  settings ||= {}
  Phalcon.configure(config, settings)

  # Configure BASH aliases
  Phalcon.try_aliases(config)

  # Copy User Files Over to VM
  Phalcon.try_copy(config, settings)

  # Register All Of The Configured Shared Folders
  Phalcon.try_folders(config, settings)

  # Configure All Of The Configured Databases
  Phalcon.try_databases(config, settings)

  if defined? VagrantPlugins::HostsUpdater
    if settings.key?('sites')
      config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
  end
end
