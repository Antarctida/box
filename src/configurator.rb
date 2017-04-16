# Configurator class
class Configurator
  # Default Port Forwarding
  DEFAULT_PORTS = {
    80 => 8000,
    443 => 44300,
    3306 => 33060,
    5432 => 54320,
    8025 => 8025,
    27017 => 27017
  }.freeze

  SRC_DIR = File.dirname(__FILE__)

  def self.configure(config, settings)
    # Set The VM Provider
    # @todo
    ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Allow SSH Agent Forward from The Box
    config.ssh.forward_agent = true

    # Configure The Box
    config.vm.define settings['name'] ||= 'phalcon-vm'
    config.vm.box = settings['box'] ||= 'phalconphp/xenial64'
    config.vm.box_version = settings['version'] ||= '>= 1.0.0'
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
      vb.name = settings['name'] ||= 'phalcon-vm'
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
      DEFAULT_PORTS.each do |guest, host|
        unless settings['ports'].any? {|m| m['guest'] == guest}
          config.vm.network 'forwarded_port', guest: guest, host: host, auto_correct: true
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

    # Copy User Files Over to VM
    if settings.include? 'copy'
      settings['copy'].each do |file|
        config.vm.provision 'file' do |f|
          f.source = File.expand_path(file['from'])
          f.destination = file['to'].chomp('/') + '/' + file['from'].split('/').last
        end
      end
    end
  end

  def self.aliases(config, aliases)
    config.vm.provision 'file', source: aliases, destination: '/tmp/bash_aliases'
    config.vm.provision "shell" do |s|
      s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
    end
  end
end
