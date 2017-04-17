require_relative 'constants'
require_relative 'prober'
require_relative 'settings'
require_relative 'database'
require_relative 'keys'
require_relative 'aliases'
require_relative 'files'
require_relative 'folders'

# The main Phalcon Box class
class Phalcon
  attr_accessor :config, :settings

  attr_reader :application_root

  def initialize(config)
    @config = config
    @application_root = File.dirname(__FILE__).to_s
  end

  def configure
    s = Settings.new(application_root)
    @settings = s.init_settings

    init

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
    ENV['VAGRANT_DEFAULT_PROVIDER'] = PHALCON_DEFAULT_PROVIDER.to_s

    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Allow SSH Agent Forward from The Box
    config.ssh.forward_agent = true

    # Configure The Box
    config.vm.define settings['name']
    config.vm.box = settings['box']
    config.vm.box_version = settings['version']
    config.vm.hostname = settings['hostname']
    config.vm.box_check_update = settings['check_update']

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings['ip']

    # Configure Additional Networks
    if settings.key?('networks')
      settings['networks'].each do |n|
        config.vm.network n['type'], ip: n['ip'], bridge: n['bridge'] ||= nil
      end
    end

    # Configure A Few VirtualBox Settings
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

    # Standardize Ports Naming Schema
    if settings.key?('ports')
      settings['ports'].each do |port|
        port['guest'] ||= port['to']
        port['host'] ||= port['send']
        port['protocol'] ||= 'tcp'
      end
    else
      settings['ports'] = []
    end

    # Use Default Port Forwarding Unless Overridden
    unless settings.key?('default_ports') && settings['default_ports'] == false
      PHALCON_DEFAULT_PORTS.each do |ports|
        unless settings['ports'].any? { |m| m['guest'] == ports[:guest] }
          config.vm.network 'forwarded_port', guest: ports[:guest], host: ports[:host], auto_correct: true
        end
      end
    end

    # Add Custom Ports From Configuration
    if settings.key?('ports')
      settings['ports'].each do |p|
        config.vm.network 'forwarded_port', guest: p['guest'], host: p['host'], protocol: p['protocol'], auto_correct: true
      end
    end

    # Configure The Public Key For SSH Access
    if settings.include? 'authorize'
      if File.exist? File.expand_path(settings['authorize'])
        config.vm.provision 'shell' do |s|
          s.inline = 'echo $1 | grep -xq "$1" /home/vagrant/.ssh/authorized_keys || echo "\n$1" | tee -a /home/vagrant/.ssh/authorized_keys'
          s.args = [File.read(File.expand_path(settings['authorize']))]
        end
      end
    end
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

  def try_sites
    if defined? VagrantPlugins::HostsUpdater
      if settings.key?('sites')
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
      end
    end
  end
end
