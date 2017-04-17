# Configure All Of The Configured Databases
class Database
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    if settings.key?('databases')
      settings['databases'].each do |db|
        mysql(db)

        postgres(db)

        if settings.key?('mongodb') && settings['mongodb']
          mongo(db)
        end
      end
    end
  end

  private

  def mysql(db)
    config.vm.provision 'shell' do |s|
      s.name = "Creating MySQL Database: #{db}"
      s.path = "#{application_root}/provision/mysql_provision.sh"
      s.args = [db]
    end
  end

  def postgres(db)
    config.vm.provision 'shell' do |s|
      s.name = "Creating Postgres Database: #{db}"
      s.path = "#{application_root}/provision/postgres_provision.sh"
      s.args = [db]
    end
  end

  def mongo(db)
    config.vm.provision 'shell' do |s|
      s.name = "Creating Mongo Database: #{db}"
      s.path = "#{application_root}/provision/mongo_provision.sh"
      s.args = [db]
    end
  end
end
