# Configure user sites
class Sites
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    clear_nginx

    if settings['sites']
      settings['sites'].each do |site|
        create_certificate(site)
        create_site(site)
      end

      update_host
    end

    restart_nginx
    restart_fpm
  end

  private

  # Clear the old Nginx sites
  def clear_nginx
    config.vm.provision :shell do |s|
      s.name = 'Clear the old Nginx sites'
      s.inline = 'rm -f /etc/nginx/sites-enabled/* /etc/nginx/sites-available/*'
    end
  end

  # Restart Nginx
  def restart_nginx
    config.vm.provision :shell do |s|
      s.name = 'Restart Nginx'
      s.inline = 'service nginx restart'
    end
  end

  # Restart PHP-FPM
  def restart_fpm
    config.vm.provision :shell do |s|
      s.name = 'Restart PHP-FPM'
      s.inline = 'service php7.1-fpm restart'
    end
  end

  def update_host
    if Vagrant.has_plugin?('vagrant-hostsupdater')
      config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
  end

  # Create SSL certificate
  def create_certificate(site)
    config.vm.provision :shell do |s|
      s.name = 'Creating certificate for: ' + site['map']
      s.path = "#{application_root}/provision/certificate.sh"
      s.args = [site['map']]
    end
  end

  # Creating site
  def create_site(site)
    config.vm.provision :shell do |s|
      site['port'] ||= 80
      site['ssl']  ||= 443

      s.name = 'Configuring site: ' + site['map']
      s.path = "#{application_root}/provision/nginx.sh"
      s.env  = server_env(site)
      s.args = [File.read("#{application_root}/templates/nginx.conf")]
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
