# Configure user sites
class Sites
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    if defined? VagrantPlugins::HostsUpdater
      if settings.key?('sites')
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
      end
    end
  end
end
