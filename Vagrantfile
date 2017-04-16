# -*- mode: ruby -*-
# vi: set ft=ruby :

path = File.dirname(__FILE__).to_s
aliases = path + '/bash_aliases'

require 'json'
require 'yaml'
require File.expand_path(path + '/src/phalcon.rb')

VAGRANTFILE_API_VERSION ||= 2

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if File.exist?(aliases)
    config.vm.provision 'file', source: aliases, destination: '/tmp/bash_aliases'
    config.vm.provision "shell" do |s|
      s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
    end
  end

  settings = {}
  if File.exist?(path + '/settings.yml')
    settings = YAML.safe_load(File.read(path + '/settings.yml'))
  end

  settings ||= {}

  Phalcon::Configurator.configure(config, settings)

  if defined? VagrantPlugins::HostsUpdater
    if settings.has_key?('sites')
      config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
  end
end
