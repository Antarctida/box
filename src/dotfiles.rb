# Donfigure dotfiles
class Dotfiles
  HOME_PATH = '/home/vagrant'.freeze

  attr_accessor :application_root, :config

  def initialize(application_root, config)
    @application_root = application_root
    @config = config
  end

  def configure
    try_copy('.inputrc')
    try_copy('.grcat')
  end

  private

  def try_copy(filename)
    file = File.join(application_root, "templates/#{filename}")
    return unless File.exist?(file)

    home_file = File.join(HOME_PATH, filename)

    config.vm.provision :shell, inline: "rm -f #{home_file}"
    config.vm.provision :file, source: file, destination: home_file
  end
end
