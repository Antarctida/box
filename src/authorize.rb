# Configure the public key for SSH access
class Authorize
  HOME_PATH = '/home/vagrant'.freeze

  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    unless settings.include?('authorize') && File.exist?(File.expand_path(settings['authorize']))
      return
    end

    keys = "#{HOME_PATH}/.ssh/authorized_keys"

    config.vm.provision :shell do |s|
      s.name   = 'Configure the public key for SSH access'
      s.inline = "echo $1 | grep -xq \"$1\" #{keys} || echo \"\n$1\" | tee -ia #{keys}"
      s.args   = [File.read(File.expand_path(settings['authorize']))]
    end
  end
end
