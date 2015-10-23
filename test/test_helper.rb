# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'minitest/autorun'
require 'mocha/mini_test'
require 'minitest/rg'
require "active_support"
require "active_record"
require "action_controller"
require 'crud_actions'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

#Establish connection to test instance creation for models

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :categories, :force => true do |t|
    t.string :text
  end

  create_table :products, :force => true do |t|
    t.string :name
  end
end

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActionController::Base.view_paths = File.join(File.dirname(__FILE__), 'views')

#Create Routes to test assertions on routings

CrudActions::Routes = ActionDispatch::Routing::RouteSet.new

CrudActions::Routes.draw do
  resources :categories
  resources :products
end

ActionController::Base.send :include, CrudActions::Routes.url_helpers

class ActionController::TestCase
  setup do
    @routes = CrudActions::Routes
  end
end
