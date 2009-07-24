require 'rubygems'
require 'stringio'
require 'spec'
require 'spec/autorun'
require 'active_record'

require File.expand_path('../lib/has_password', File.dirname(__FILE__))

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :dbfile => ':memory:'
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :username
    t.string :password_hash
    t.string :password_salt
    t.integer :count
  end
end

class User < ActiveRecord::Base
  
  has_password
  
  before_validation do |m|
    m.count ||= 0
  end
  
  after_password_change :increment!
  
  def increment!
    self.count = count + 1
  end
  
  after_password_change do |m|
    m.username = 'changed'
  end
  
end