# Configure Composer
class Composer
  attr_accessor :config

  def initialize(config)
    @config = config
  end

  def configure
    config.vm.provision 'shell' do |s|
      s.name = 'Update Composer'
      s.inline = 'sudo /usr/local/bin/composer self-update && ' \
                 'sudo chown -R vagrant:vagrant /home/vagrant/.composer'
      s.privileged = false
    end
  end
end
