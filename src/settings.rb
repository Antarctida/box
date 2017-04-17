# Initialize user settings
class Settings
  attr_accessor :application_root

  def initialize(application_root)
    @application_root = application_root

    init_settings
  end

  def init_settings
    settings = {}
    file = application_root + '/../settings.yml'

    if File.exist?(file)
      settings = YAML.safe_load(File.read(file))
    end

    settings ||= {}
    settings['name']               ||= 'box'
    settings['box']                ||= 'phalconphp/xenial64'
    settings['version']            ||= ">= #{PHALCON_BOX_VERSION}"
    settings['hostname']           ||= 'phalcon.local'
    settings['check_update']         = true
    settings['ip']                 ||= PHALCON_DEFAULT_IP.to_s
    settings['memory']             ||= 2048
    settings['cpus']               ||= 1
    settings['natdnshostresolver'] ||= 'on'

    @settings = settings
  end
end
