# -*- mode: ruby -*-
# frozen_string_literal: true

require_relative 'prober'

# Initialize user settings
class Settings
  DEFAULT_IP = '192.168.50.4'
  BOX_VERSION = '2.0.3'
  DEFAULT_CPUS = 2
  DEFAULT_MEMORY = 2048

  DEFAULT_SETTINGS = {
    name: 'pbox',
    box:  'phalconphp/xenial64',
    version: ">= #{BOX_VERSION}",
    hostname: 'phalcon.local',
    ip: DEFAULT_IP.to_s,
    natdnshostresolver: 'on',
    vram: 100,
    verbose: false,
    provider: :virtualbox,
    check_update: true
  }.freeze

  attr_accessor :application_root, :settings

  def initialize(application_root)
    @application_root = application_root

    load_file
    initialize_defaults
  end

  private

  def initialize_defaults
    opts = DEFAULT_SETTINGS.merge(@settings)

    # at least 1 GB
    memory = setup_memory
    if memory.to_i < 1024
      memory = 1024
    end

    opts['memory'] = memory
    opts['cpus'] = setup_cpu

    @settings = opts
  end

  def load_file
    file = application_root + '/../settings.yml'
    return {} until File.exist? file

    settings = YAML.safe_load(File.read(file))
    settings ||= {}

    @settings = settings
  end

  def setup_cpu
    return DEFAULT_CPUS unless settings.key?('cpus')

    if settings['cpus'] =~ /auto/
      if Prober.mac?
        `sysctl -n hw.ncpu`.to_i
      elsif Prober.linux?
        `nproc`.to_i
      else
        DEFAULT_CPUS
      end
    else
      settings['cpus'].to_i
    end
  end

  def setup_memory
    return DEFAULT_MEMORY unless settings.key?('memory')

    if settings['memory'] =~ /auto/
      if Prober.mac?
        `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
      elsif Prober.linux?
        `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
      else
        DEFAULT_MEMORY
      end
    else
      settings['cpus'].to_i
    end
  end
end
