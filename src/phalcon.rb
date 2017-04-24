require_relative 'settings'
require_relative 'authorize'
require_relative 'ports'
require_relative 'keys'
require_relative 'aliases'
require_relative 'folders'
require_relative 'database'
require_relative 'vbguest'
require_relative 'networks'
require_relative 'virtualbox'
require_relative 'variables'
require_relative 'sites'
require_relative 'composer'
require_relative 'dotfiles'
require_relative 'files'
require_relative 'motd'

# The main Phalcon Box class
class Phalcon
  VERSION = '2.0.2'.freeze
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
    try_vbguest
    try_networks
    try_virtualbox
    try_ports
    try_authorize
    try_keys
    try_aliases
    try_dotfiles
    try_folders
    try_databases
    try_variables
    try_sites
    try_composer
    try_files
    try_motd
  end

  def init
    # Set The VM Provider
    # @todo
    ENV['VAGRANT_DEFAULT_PROVIDER'] = DEFAULT_PROVIDER.to_s

    init_ssh
    init_box
  end

  def show_banner
    config.vm.provision :shell, inline: 'echo Phalcon Box provisioned!'
  end

  private

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

  # Configure BASH aliases
  def try_aliases
    aliases = Aliases.new(application_root, config)
    aliases.configure
  end

  # Donfigure dotfiles
  def try_dotfiles
    dotfiles = Dotfiles.new(application_root, config)
    dotfiles.configure
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

  # Configure all of the configured databases
  def try_databases
    db = Database.new(application_root, config, settings)
    db.configure
  end

  # Configure environment variables
  def try_variables
    variables = Variables.new(application_root, config, settings)
    variables.configure
  end

  # Configure user sites
  def try_sites
    sites = Sites.new(application_root, config, settings)
    sites.configure
  end

  # Update Composer on every provision
  def try_composer
    composer = Composer.new(config)
    composer.configure
  end

  # Configure Message of the Day
  def try_motd
    motd = Motd.new(application_root, config, settings)
    motd.configure
  end
end
