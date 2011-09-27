# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../sample/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For Generators
require 'rails/generators/test_case'


class Rails::Generators::TestCase
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  
  def javascripts_path
    "app/assets/javascripts/"
  end
  
end
