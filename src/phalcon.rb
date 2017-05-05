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
    @application_root = File.dirname(File.dirname(__FILE__)).to_s

    s = Settings.new(application_root)
    @settings = s.settings

    ENV['VAGRANT_DEFAULT_PROVIDER'] = settings[:provider].to_s

    configure_ssh
    configure_box
  end

  def configure
    configure_vbguest
    configure_networks
    configure_vms
    configure_ports
    configure_authorize
    configure_keys
    configure_folders
    configure_variables
    configure_files
  end

  # Start provisioning
  def provision
    config.vm.provision 'ansible_local' do |ansible|
      ansible.playbook = 'provisioning/main.yml'
      ansible.limit = :all
      ansible.extra_vars = { settings: settings }
      ansible.verbose = settings[:verbose]
    end

    return unless Vagrant.has_plugin? 'vagrant-hostsupdater'

    config.hostsupdater.aliases = settings[:sites].map { |site| site[:map] }
  end

  def after_provision
    provision = File.join application_root, 'after_provision.sh'
    return until File.exist? provision

    config.vm.provision :shell, path: provision, privileged: false
  end

  private

  # Configure SSH
  def configure_ssh
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.ssh.forward_agent = true
  end

  # Configure the Box
  def configure_box
    config.vm.define settings[:name], primary: true do |c|
      c.vm.box = settings[:box]
      c.vm.box_version = settings[:version]
      c.vm.hostname = settings[:hostname]
      c.vm.box_check_update = settings[:check_update]
    end
  end

  # Configure Virtualbox Guest Additions
  def configure_vbguest
    vbguest = Vbguest.new(config, settings)
    vbguest.configure
  end

  # Configure networks
  def configure_networks
    networks = Networks.new(config, settings)
    networks.configure
  end

  # Configure VMs
  def configure_vms
    virtualbox = Virtualbox.new(config, settings)
    virtualbox.configure

    vmware = VMWare.new(config, settings)
    vmware.configure
  end

  # Configure custom ports
  def configure_ports
    ports = Ports.new(config, settings)
    ports.configure
  end

  # Configure the public key for SSH access
  def configure_authorize
    authorize = Authorize.new(config, settings)
    authorize.configure
  end

  # Copy the SSH private keys to the box
  def configure_keys
    aliases = Keys.new(config, settings)
    aliases.configure
  end

  # Copy user files over to VM
  def configure_files
    files = Files.new(config, settings)
    files.configure
  end

  # Register all of the configured shared folders
  def configure_folders
    folders = Folders.new(config, settings)
    folders.configure
  end

  # Configure environment variables
  def configure_variables
    variables = Variables.new(config, settings)
    variables.configure
  end
end
