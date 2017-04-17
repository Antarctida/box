# Register all of the configured shared folders
class Folders
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    if settings.include? 'folders'
      settings['folders'].each do |folder|
        if File.exist? File.expand_path(folder['map'])
          user_folder(folder)
        else
          notify
        end
      end
    end
  end

  private

  def user_folder(folder)
    opts = mount_opts(folder)

    # For b/w compatibility keep separate 'mount_opts', but merge with options
    options = (folder['options'] || {}).merge mount_options: opts

    # Double-splat (**) operator only works with symbol keys, so convert
    options.keys.each { |k| options[k.to_sym] = options.delete(k) }

    config.vm.synced_folder folder['map'], folder['to'], type: folder['type'] ||= nil, **options

    # Bindfs support to fix shared folder (NFS) permission issue on Mac
    if Vagrant.has_plugin?('vagrant-bindfs')
      config.bindfs.bind_folder folder['to'], folder['to']
    end
  end

  def notify
    config.vm.provision 'shell' do |s|
      s.inline = '>&2 echo "Unable to mount one of your folders. ' \
                 'Please check your folders in settings.yml"'
    end
  end

  def mount_opts(folder)
    if folder['type'] == 'nfs'
      folder['mount_options'] || %w[actimeo=1 nolock]
    elsif folder['type'] == 'smb'
      folder['mount_options'] || %w[vers=3.02 mfsymlinks]
    else
      []
    end
  end
end
