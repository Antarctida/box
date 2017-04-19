# Initialize user settings
class Settings
  DEFAULT_IP = '192.168.50.4'.freeze
  BOX_VERSION = '1.0.4'.freeze

  attr_accessor :application_root, :settings

  def initialize(application_root)
    @application_root = application_root

    load_file
    defaults
  end

  private

  def defaults
    settings['name']               ||= 'box'
    settings['box']                ||= 'phalconphp/xenial64'
    settings['version']            ||= ">= #{BOX_VERSION}"
    settings['hostname']           ||= 'phalcon.local'
    settings['check_update']         = true
    settings['ip']                 ||= DEFAULT_IP.to_s
    settings['memory']             ||= 2048
    settings['cpus']               ||= 1
    settings['natdnshostresolver'] ||= 'on'
  end

  def load_file
    settings = {}
    file = application_root + '/../settings.yml'

    if File.exist?(file)
      settings = YAML.safe_load(File.read(file))
    end

    settings ||= {}

    @settings = settings
  end
end
