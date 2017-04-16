# -*- mode: ruby -*-
# vi: set ft=ruby :

path = File.dirname(__FILE__).to_s

require 'json'
require 'yaml'
require File.expand_path(path + '/src/phalcon.rb')

VAGRANTFILE_API_VERSION ||= 2

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if File.exist?(path + '/vm.yml')
    settings = YAML.safe_load(File.read(path + '/vm.yml'))
  else
    settings = {}
    warn "Vagrant settings file not found in #{path}"
  end

  Phalcon.configure(config, settings)
end
