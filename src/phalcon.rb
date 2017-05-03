# -*- mode: ruby -*-
# frozen_string_literal: true

require_relative 'settings'
require_relative 'authorize'
require_relative 'ports'
require_relative 'keys'
require_relative 'folders'
require_relative 'vbguest'
require_relative 'networks'
require_relative 'virtualbox'
require_relative 'variables'
require_relative 'blackfire'
require_relative 'sites'
require_relative 'files'

# The main Phalcon Box class
class Phalcon
  VERSION = '2.3.0'
  DEFAULT_PROVIDER = 'virtualbox'

  attr_accessor :config, :settings

  attr_reader :application_root

  def initialize(config)
    @config = config
    @application_root = File.dirname(__FILE__).to_s

    s = Settings.new(application_root)
    @settings = s.settings

    init
  end

  def configure
    try_vbguest
    try_networks
    try_virtualbox
    try_ports
    try_authorize
    try_keys
    try_folders
    try_variables
    try_blackfire
    try_sites
    try_files
  end

  # Start provisioning
  def provision
    config.vm.provision 'ansible_local' do |ansible|
      ansible.playbook = 'provisioning/main.yml'
      ansible.limit = :all
      ansible.extra_vars = { settings: settings }
      ansible.verbose = settings['verbose']
    end
  end

  def welcome
    config.vm.provision :shell, inline: 'echo Phalcon Box provisioned!'
  end

  private

  def init
    # Set The VM Provider
    # @todo
    ENV['VAGRANT_DEFAULT_PROVIDER'] = DEFAULT_PROVIDER.to_s

    init_ssh
    init_box
  end

  # Configure SSH
  def init_ssh
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.ssh.forward_agent = true
  end

  # Configure The Box
  def init_box
    config.vm.define settings['name']
    config.vm.box = settings['box']
    config.vm.box_version = settings['version']
    config.vm.hostname = settings['hostname']
    config.vm.box_check_update = settings['check_update']
  end

  # Configure Virtualbox Guest Additions
  def try_vbguest
    vbguest = Vbguest.new(config, settings)
    vbguest.configure
  end

  # Configure networks
  def try_networks
    networks = Networks.new(config, settings)
    networks.configure
  end

  # Configure VirtualBox
  def try_virtualbox
    virtualbox = Virtualbox.new(config, settings)
    virtualbox.configure
  end

  # Configure custom ports
  def try_ports
    ports = Ports.new(config, settings)
    ports.configure
  end

  # Configure the public key for SSH access
  def try_authorize
    authorize = Authorize.new(config, settings)
    authorize.configure
  end

  # Copy the SSH private keys to the box
  def try_keys
    aliases = Keys.new(config, settings)
    aliases.configure
  end

  # Copy user files over to VM
  def try_files
    files = Files.new(config, settings)
    files.configure
  end

  # Register all of the configured shared folders
  def try_folders
    folders = Folders.new(application_root, config, settings)
    folders.configure
  end

  # Configure environment variables
  def try_variables
    variables = Variables.new(application_root, config, settings)
    variables.configure
  end

  # Configure Blackfire.io
  def try_blackfire
    blackfire = Blackfire.new(application_root, config, settings)
    blackfire.configure
  end

  # Configure user sites
  def try_sites
    sites = Sites.new(application_root, config, settings)
    sites.configure
  end
end
