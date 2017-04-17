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
        create_certificate(site)
        create_site(site)
      end

      update_host
    end
  end

  private

  def update_host
    if Vagrant.has_plugin?('vagrant-hostsupdater')
      config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
  end

  # Create SSL certificate
  def create_certificate(site)
    config.vm.provision 'shell' do |s|
      s.name = 'Creating certificate for: ' + site['map']
      s.path = "#{application_root}/provision/certificate_provision.sh"
      s.args = [site['map']]
    end
  end

  # Creating site
  def create_site(site)
    config.vm.provision 'shell' do |s|
      site['port'] ||= 80
      site['ssl']  ||= 443

      s.name = 'Configuring site: ' + site['map']
      s.path = "#{application_root}/provision/nginx_provision.sh"
      s.env  = server_env(site)

      file = File.open("#{application_root}/templates/nginx.conf", 'rb')
      s.args = [file.read]
    end
  end

  def server_env(site)
    {
      TPL_HTTP_PORT:     site['port'],
      TPL_SSL_PORT:      site['ssl'],
      TPL_SERVER_NAME:   site['map'],
      TPL_DOCUMENT_ROOT: site['to']
    }
  end
end
