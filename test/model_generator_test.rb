require 'test_helper'
require 'generators/batman/model_generator'

class ModelGeneratorTest < Rails::Generators::TestCase
  tests Batman::Generators::ModelGenerator
  
  test "simple model" do
    run_generator %w(Task title:string created_at:date)
    
    assert_file "#{javascripts_path}/models/task.js.coffee" do |model|
      model_class = Regexp.escape("class Sample.Task extends Batman.Model")
      
      assert_match /#{model_class}/, model
      
      assert_match /@storageKey: 'tasks'/, model
      assert_match /@persist Batman.RailsStorage/, model
      
      assert_match /@encode 'title'/, model
      assert_match /@encode 'created_at', Batman.Encoders.railsDate/, model
    end
  end
  
  test "two word model is camelcased" do
    run_generator %w(RegularUser name:string)
    
    assert_file "#{javascripts_path}/models/regular_user.js.coffee" do |model|
      model_class = Regexp.escape("class Sample.RegularUser extends Batman.Model")
      
      assert_match /#{model_class}/, model
      
      assert_match /@storageKey: 'regular_users'/, model
    end
  end
  
  test "simple model with app_name" do
    run_generator %w(Task title:string created_at:date --app_name MyApp)
    
    assert_file "#{javascripts_path}/models/task.js.coffee" do |model|
      model_class = Regexp.escape("class MyApp.Task extends Batman.Model")
      
      assert_match /#{model_class}/, model
    end
  end
end
