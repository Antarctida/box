require_relative 'prober'
require_relative 'settings'
require_relative 'authorize'
require_relative 'ports'
require_relative 'keys'
require_relative 'aliases'
require_relative 'files'
require_relative 'folders'
require_relative 'database'
require_relative 'sites'
require_relative 'networks'

# The main Phalcon Box class
class Phalcon
  VERSION = '2.0.0'.freeze
  DEFAULT_PROVIDER = 'virtualbox'.freeze

  attr_accessor :config, :settings

  attr_reader :application_root

  def initialize(config)
    @config = config
    @application_root = File.dirname(__FILE__).to_s

    s = Settings.new(application_root)
    @settings = s.settings
  end

  def configure
    init

    try_ports
    try_authorize
    try_keys
    try_aliases
    try_copy
    try_folders
    try_databases
    try_sites
  end

  private

  def init
    # Set The VM Provider
    # @todo
    ENV['VAGRANT_DEFAULT_PROVIDER'] = DEFAULT_PROVIDER.to_s

    init_ssh
    init_box
    init_network
    try_networks
    init_virtualbox
  end

  # Configure SSH
  def init_ssh
    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Allow SSH Agent Forward from The Box
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

  def init_network
    config.vm.network :private_network, ip: settings['ip']
  end

  # Configure Additional Networks
  def try_networks
    networks = Networks.new(config, settings)
    networks.configure
  end

  # Configure A Few VirtualBox Settings
  def init_virtualbox
    config.vm.provider 'virtualbox' do |vb|
      vb.name = settings['name'] ||= 'box'
      vb.customize ['modifyvm', :id, '--memory', settings['memory']]
      vb.customize ['modifyvm', :id, '--cpus', settings['cpus']]
      vb.customize ['modifyvm', :id, '--ioapic', 'on']
      vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', settings['natdnshostresolver']]
      vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
      vb.gui = true if settings['gui']
    end
  end

  # Add Custom Ports From Configuration
  def try_ports
    ports = Ports.new(config, settings)
    ports.configure
  end

  # Configure The Public Key For SSH Access
  def try_authorize
    authorize = Authorize.new(config, settings)
    authorize.configure
  end

  # Copy The SSH Private Keys To The Box
  def try_keys
    aliases = Keys.new(config, settings)
    aliases.configure
  end

  # Configure BASH aliases
  def try_aliases
    aliases = Aliases.new(application_root, config)
    aliases.configure
  end

  # Copy User Files Over to VM
  def try_copy
    files = Files.new(config, settings)
    files.configure
  end

  # Register All Of The Configured Shared Folders
  def try_folders
    folders = Folders.new(application_root, config, settings)
    folders.configure
  end

  # Configure All Of The Configured Databases
  def try_databases
    db = Database.new(application_root, config, settings)
    db.configure
  end

  # Configure user sites
  def try_sites
    sites = Sites.new(config, settings)
    sites.configure
  end
end
