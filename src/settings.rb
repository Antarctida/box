# -*- mode: ruby -*-
# frozen_string_literal: true

require 'pp'
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

    initialize_defaults
  end

  private

  def initialize_defaults
    @settings = DEFAULT_SETTINGS.merge(load_file)

    memory = setup_memory

    settings[:memory] = 1024 if memory.to_i < 1024
    settings[:cpus] = setup_cpu
  end

  def load_file
    file = File.join application_root, 'settings.yml'

    if File.exist? file
      opts = YAML.safe_load(File.read(file)) || {}
    else
      opts = {}
    end

    symbolize(opts)
  end

  def symbolize(obj)
    if obj.is_a? Hash
      obj.inject({}) { |memo, (k, v)| memo[k.to_sym] = symbolize(v); memo }
    elsif obj.is_a? Array
      obj.inject([]) { |memo, v| memo << symbolize(v); memo }
    else
      obj
    end
  end

  def call_system(linux, osx, default)
    if Prober.mac?
      `#{osx}`
    elsif Prober.linux?
      `#{linux}`
    else
      default
    end
  end

  def setup_cpu
    return DEFAULT_CPUS unless settings[:cpus]
    return settings[:cpus].to_i unless settings[:cpus] == 'auto'

    call_system('nproc', 'sysctl -n hw.ncpu', DEFAULT_CPUS).to_i
  end

  def setup_memory
    return DEFAULT_MEMORY unless settings[:memory]
    return settings[:memory].to_i unless settings[:memory] == 'auto'

    if Prober.mac?
      `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif Prober.linux?
      `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else
      DEFAULT_MEMORY
    end
  end
end
