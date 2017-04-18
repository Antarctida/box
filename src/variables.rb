# Configure environment variables
class Variables
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    clear

    if settings.key?('variables')
      settings['variables'].each do |var|
        env_var(var)
        fpm_var(var)
      end
    end
  end

  def env_var(var)
    config.vm.provision 'shell' do |s|
      s.inline = "echo \"\n; Phalcon Box environment variable\nenv[$1]='$2'\" >> /etc/php/7.1/fpm/php-fpm.conf"
      s.args = [var['key'], var['value']]
    end
  end

  def fpm_var(var)
    config.vm.provision 'shell' do |s|
      s.inline = "echo \"\n# Phalcon Box environment variable\nexport $1=$2\" >> /home/vagrant/.profile"
      s.args = [var['key'], var['value']]
    end
  end

  def clear
    config.vm.provision 'shell' do |s|
      s.name = 'Clear environment variables'
      s.path = "#{application_root}/provision/variables.sh"
    end
  end
end
