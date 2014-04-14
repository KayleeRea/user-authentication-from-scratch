ENV['RACK_ENV'] = 'test'

require_relative '../boot'
require 'sequel'
require 'lib/tasks/db'

DB = Sequel.connect('postgres://gschool_user:password@localhost/authentication_test')

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    migration_task = Rake::Task['db:migrate']
    migration_task.invoke(0)
    migration_task.reenable
    migration_task.invoke
  end
end