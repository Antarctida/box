# Configure BASH aliases
class Aliases
  VM_PATH = '/home/vagrant/.bash_aliases'.freeze

  attr_accessor :application_root, :config

  def initialize(application_root, config)
    @application_root = application_root
    @config = config
  end

  def configure
    aliases = File.join(File.dirname(application_root), '.bash_aliases')
    return unless File.exist?(aliases)

    config.vm.provision :shell, inline: "rm -f #{VM_PATH}"
    config.vm.provision :file, source: aliases, destination: VM_PATH
  end
end
