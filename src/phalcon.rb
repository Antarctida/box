require_relative 'prober'
require_relative 'version'

# The main Phalcon Box module
module Phalcon
  class << self
    # @return [String]
    attr_accessor :application_root
  end

  # Default Port Forwarding
  DEFAULT_PORTS = [
    { guest: 80,    host: 8000  },
    { guest: 443,   host: 44300 },
    { guest: 3306,  host: 33060 },
    { guest: 5432,  host: 54320 },
    { guest: 8025,  host: 8025  },
    { guest: 27017, host: 27017 }
  ].freeze

  def self.configure(config, settings)
    # Set The VM Provider
    # @todo
    ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Allow SSH Agent Forward from The Box
    config.ssh.forward_agent = true

    # Configure The Box
    config.vm.define settings['name'] ||= 'box'
    config.vm.box = settings['box'] ||= 'phalconphp/xenial64'
    config.vm.box_version = settings['version'] ||= ">= #{BOX_VERSION}"
    config.vm.hostname = settings['hostname'] ||= 'phalcon.local'
    config.vm.box_check_update = true

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings['ip'] ||= '192.168.50.4'

    # Configure Additional Networks
    if settings.key?('networks')
      settings['networks'].each do |n|
        config.vm.network n['type'], ip: n['ip'], bridge: n['bridge'] ||= nil
      end
    end

    # Configure A Few VirtualBox Settings
    config.vm.provider 'virtualbox' do |vb|
      vb.name = settings['name'] ||= 'box'
      vb.customize ['modifyvm', :id, '--memory', settings['memory'] ||= '2048']
      vb.customize ['modifyvm', :id, '--cpus', settings['cpus'] ||= '1']
      vb.customize ['modifyvm', :id, '--ioapic', 'on']
      vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', settings['natdnshostresolver'] ||= 'on']
      vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
      if settings.key?('gui') && settings['gui']
        vb.gui = true
      end
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
      DEFAULT_PORTS.each do |ports|
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

    # Copy The SSH Private Keys To The Box
    if settings.include? 'keys'
      settings['keys'].each do |key|
        config.vm.provision 'shell' do |s|
          s.privileged = false
          s.inline = 'echo "$1" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2'
          s.args = [File.read(File.expand_path(key)), key.split('/').last]
        end
      end
    end
  end

  # Copy User Files Over to VM
  def self.try_copy(config, settings)
    if settings.include? 'copy'
      settings['copy'].each do |file|
        config.vm.provision 'file' do |f|
          f.source = File.expand_path(file['from'])
          f.destination = file['to'].chomp('/') + '/' + file['from'].split('/').last
        end
      end
    end
  end

  # Register All Of The Configured Shared Folders
  def self.try_folders(config, settings)
    if settings.include? 'folders'
      settings['folders'].each do |f|
        if File.exist? File.expand_path(f['map'])
          mount_opts = []

          if f['type'] == 'nfs'
            mount_opts = f['mount_options'] ? f['mount_options'] : ['actimeo=1', 'nolock']
          elsif f['type'] == 'smb'
            mount_opts = f['mount_options'] ? f['mount_options'] : ['vers=3.02', 'mfsymlinks']
          end

          # For b/w compatibility keep separate 'mount_opts', but merge with options
          options = (f['options'] || {}).merge mount_options: mount_opts

          # Double-splat (**) operator only works with symbol keys, so convert
          options.keys.each { |k| options[k.to_sym] = options.delete(k) }

          config.vm.synced_folder f['map'], f['to'], type: f['type'] ||= nil, **options

          # Bindfs support to fix shared folder (NFS) permission issue on Mac
          if Vagrant.has_plugin?('vagrant-bindfs')
            config.bindfs.bind_folder f['to'], f['to']
          end
        else
          config.vm.provision 'shell' do |s|
            s.inline = '>&2 echo \"Unable to mount one of your folders.\"'
            s.inline = '>&2 echo \"Please check your folders in settings.yml\"'
          end
        end
      end
    end
  end

  # Configure All Of The Configured Databases
  def self.try_databases(config, settings)
    if settings.key?('databases')
      settings['databases'].each do |db|
        config.vm.provision 'shell' do |s|
          s.name = "Creating MySQL Database: #{db}"
          s.path = "#{application_root}/provision/mysql_provision.sh"
          s.args = [db]
        end

        config.vm.provision 'shell' do |s|
          s.name = "Creating Postgres Database: #{db}"
          s.path = "#{application_root}/provision/mysql_provision.sh"
          s.args = [db]
        end

        if settings.key?('mongodb') && settings['mongodb']
          config.vm.provision 'shell' do |s|
            s.name = "Creating Mongo Database: #{db}"
            s.path = "#{application_root}/provision/mysql_provision.sh"
            s.args = [db]
          end
        end
      end
    end
  end

  # Configure BASH aliases
  def self.try_aliases(config)
    aliases = application_root + '/bash_aliases'

    if File.exist?(aliases)
      config.vm.provision 'file', source: aliases, destination: '/tmp/bash_aliases'
      config.vm.provision "shell" do |s|
        s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
      end
    end
  end
end
