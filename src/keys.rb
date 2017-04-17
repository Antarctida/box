# Copy The SSH Private Keys To The Box
class Keys
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
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
end
