# Configure BASH aliases
class Aliases
  attr_accessor :application_root, :config

  def initialize(application_root, config)
    @application_root = application_root
    @config = config
  end

  def configure
    aliases = application_root + '/../bash_aliases'

    if File.exist?(aliases)
      config.vm.provision 'file', source: aliases, destination: '/tmp/bash_aliases'
      config.vm.provision "shell" do |s|
        s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
      end
    end
  end
end
