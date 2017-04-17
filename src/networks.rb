# Configure Additional Networks
class Networks
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    if settings.key?('networks')
      settings['networks'].each do |n|
        config.vm.network n['type'], ip: n['ip'], bridge: n['bridge'] ||= nil
      end
    end
  end
end
