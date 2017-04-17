# Configure the public key for SSH access
class Authorize
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    if settings.include? 'authorize'
      if File.exist? File.expand_path(settings['authorize'])
        config.vm.provision 'shell' do |s|
          s.inline = 'echo $1 | grep -xq "$1" /home/vagrant/.ssh/authorized_keys || echo "\n$1" | tee -a /home/vagrant/.ssh/authorized_keys'
          s.args = [File.read(File.expand_path(settings['authorize']))]
        end
      end
    end
  end
end
