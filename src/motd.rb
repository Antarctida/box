# Configure Message of the Day
class Motd
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    config.vm.provision :shell do |s|
      s.name = 'Configure Message of the Day'
      s.inline = <<-EOF
        rm -f /etc/update-motd.d/00-header
        rm -f /etc/update-motd.d/10-help-text
        echo "$1" | tee /etc/update-motd.d/00-header > /dev/null 2>&1
        chmod +x /etc/update-motd.d/00-header
      EOF
      s.args = [File.read("#{application_root}/templates/00-header")]
    end
  end
end
