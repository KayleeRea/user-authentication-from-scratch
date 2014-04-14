require_relative './boot'
require 'sequel'

DB = Sequel.connect('postgres://gschool_user:password@localhost/authentication_development')

run Application