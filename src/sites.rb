# Configure user sites
class Sites
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    if settings.include? 'sites'
      settings['sites'].each do |site|
        certificate(site)
      end

      update_host
    end
  end

  private

  def update_host
    if defined? VagrantPlugins::HostsUpdater
      config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
  end

  # Create SSL certificate
  def certificate(site)
    config.vm.provision 'shell' do |s|
      s.name = 'Creating certificate for: ' + site['map']
      s.path = "#{application_root}/provision/certificate_provision.sh"
      s.args = [site['map']]
    end
  end
end
