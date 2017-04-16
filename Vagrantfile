# -*- mode: ruby -*-
# vi: set ft=ruby :

path = File.dirname(__FILE__).to_s

require 'json'
require 'yaml'
require File.expand_path(path + '/src/configurator.rb')

VAGRANTFILE_API_VERSION ||= 2

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  settings = {}
  if File.exist?(path + '/settings.yml')
    settings = YAML.safe_load(File.read(path + '/settings.yml'))
  end

  settings ||= {}
  Configurator.configure(config, settings)

  # Configure BASH aliases
  Configurator.try_aliases(config, path)

  # Copy User Files Over to VM
  Configurator.try_copy(config, settings)

  # Register All Of The Configured Shared Folders
  Configurator.try_folders(config, settings)

  # Configure All Of The Configured Databases
  Configurator.try_databases(config, settings)

  if defined? VagrantPlugins::HostsUpdater
    if settings.key?('sites')
      config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
  end
end
