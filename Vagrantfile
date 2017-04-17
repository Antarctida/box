# -*- mode: ruby -*-
# vi: set ft=ruby :

path = File.dirname(__FILE__).to_s

require 'json'
require 'yaml'
require File.expand_path(path + '/src/phalcon.rb')

VAGRANTFILE_API_VERSION ||= 2

Vagrant.require_version '>= 1.9.0'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  settings = {}
  if File.exist?(path + '/settings.yml')
    settings = YAML.safe_load(File.read(path + '/settings.yml'))
  end

  settings ||= {}

  phalcon = Phalcon.new(config, settings)
  phalcon.configure
end
