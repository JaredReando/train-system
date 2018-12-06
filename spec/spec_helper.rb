require 'rspec'
require 'pg'
require 'pry'
require 'train'
require 'city'
require 'stop'
require 'rider'
require 'ticket'

DB = PG.connect({:dbname => 'train_system_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM cities *")
    DB.exec("DELETE FROM trains *")
    DB.exec("DELETE FROM stops *")
    DB.exec("DELETE FROM riders *")
    DB.exec("DELETE FROM tickets *")
  end
end
