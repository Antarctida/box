# Configure all of the configured databases
class Database
  attr_accessor :application_root, :config, :settings

  def initialize(application_root, config, settings)
    @application_root = application_root
    @config = config
    @settings = settings
  end

  def configure
    return unless settings.key?('databases')

    settings['databases'].each do |db|
      mysql(db)
      postgres(db)
      mongo(db)
    end
  end

  private

  def mysql(db)
    config.vm.provision :shell do |s|
      s.name = "Creating MySQL Database: #{db}"
      s.path = "#{application_root}/provision/mysql.sh"
      s.args = [db]
    end
  end

  def postgres(db)
    config.vm.provision :shell do |s|
      s.name = "Creating Postgres Database: #{db}"
      s.path = "#{application_root}/provision/postgres.sh"
      s.args = [db]
    end
  end

  def mongo(db)
    config.vm.provision :shell do |s|
      s.name = "Creating Mongo Database: #{db}"
      s.inline = 'mongo $1 --quiet --eval "$2"'
      s.args = [
        db,
        File.read("#{application_root}/templates/mongo_create_db.js")
      ]
    end
  end
end
