require 'rubygems'
require 'stringio'
require 'test/unit'
require 'active_record'

require File.expand_path('../lib/has_password', File.dirname(__FILE__))

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :dbfile => ':memory:'
require File.expand_path('fixtures/schema', File.dirname(__FILE__))
require File.expand_path('fixtures/user', File.dirname(__FILE__))