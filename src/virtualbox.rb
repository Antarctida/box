# Configure VirtualBox
class Virtualbox
  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings
  end

  def configure
    config.vm.provider 'virtualbox' do |vb|
      vb.name = settings['name'] ||= 'box'
      vb.customize ['modifyvm', :id, '--memory', settings['memory']]
      vb.customize ['modifyvm', :id, '--cpus', settings['cpus']]
      vb.customize ['modifyvm', :id, '--ioapic', 'on']
      vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', settings['natdnshostresolver']]
      vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
      vb.gui = true if settings['gui']
    end
  end
end
