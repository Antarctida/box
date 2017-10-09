# -*- mode: ruby -*-
# frozen_string_literal: true

# Configure VMWare
class VMWare
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    %i(vmware_desktop vmware_fusion vmware_workstation).each do |vmware|
      customize vmware
    end
  end

  def customize(vmware)
    config.vm.provider vmware do |v|
      v.vmx['displayName'] = settings[:name]
      v.vmx['memsize'] = settings[:memory]
      v.vmx['numvcpus'] = settings[:cpus]
      v.vmx['guestOS'] = 'ubuntu-64'
      v.whitelist_verified = true
      v.gui = true if settings[:gui]
    end
  end
end
