# -*- mode: ruby -*-
# frozen_string_literal: true

# Configure networks
class Networks
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    config.vm.network :private_network, ip: settings['ip']

    return unless settings.key?('networks')

    settings['networks'].each do |n|
      config.vm.network n['type'], ip: n['ip'], bridge: n['bridge'] ||= nil
    end
  end
end
