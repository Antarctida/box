# Initialize user settings
class Settings
  DEFAULT_IP = '192.168.50.4'.freeze
  BOX_VERSION = '1.0.1'.freeze

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
    settings['version']            ||= ">= #{BOX_VERSION}"
    settings['hostname']           ||= 'phalcon.local'
    settings['check_update']         = true
    settings['ip']                 ||= DEFAULT_IP.to_s
    settings['memory']             ||= 2048
    settings['cpus']               ||= 1
    settings['natdnshostresolver'] ||= 'on'

    @settings = settings
  end
end
