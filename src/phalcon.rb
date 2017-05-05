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
require_relative 'vmware'
require_relative 'variables'
require_relative 'files'

# The main Phalcon Box class
class Phalcon
  VERSION = '2.3.0'

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
    try_vms
    try_ports
    try_authorize
    try_keys
    try_folders
    try_variables
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

    return unless Vagrant.has_plugin? 'vagrant-hostsupdater'

    config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
  end

  def after_provision
    user_provision = File.join File.dirname(application_root), 'after_provision.sh'
    return until File.exist? user_provision

    config.vm.provision :shell, path: user_provision, privileged: false
  end

  private

  def init
    ENV['VAGRANT_DEFAULT_PROVIDER'] = settings['provider'] ||= :virtualbox

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

  # Configure VMs
  def try_vms
    virtualbox = Virtualbox.new(config, settings)
    virtualbox.configure

    vmware = VMWare.new(config, settings)
    vmware.configure
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
end
