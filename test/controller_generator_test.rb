require 'test_helper'
require 'generators/batman/controller_generator'

class ControllerGeneratorTest < Rails::Generators::TestCase
  tests Batman::Generators::ControllerGenerator
  
  test "simple controller" do
    run_generator %w(Task index show)
    
    assert_file "#{javascripts_path}/controllers/tasks_controller.js.coffee" do |controller|
      controller_class = Regexp.escape("class Sample.TasksController extends Batman.Controller")
      
      assert_match /#{controller_class}/, controller
      assert_match %r{  index: \(params\) ->}, controller
      assert_match %r{  show: \(params\) ->}, controller
    end
  end
  
  test "two word controller is camelcased" do
    run_generator %w(RegularUser index)
    
    assert_file "#{javascripts_path}/controllers/regular_users_controller.js.coffee" do |controller|
      controller_class = Regexp.escape("class Sample.RegularUsersController extends Batman.Controller")
      
      assert_match /#{controller_class}/, controller
      assert_match %r{  index: \(params\) ->}, controller
    end
  end
  
  test "simple controller with app_name" do
    run_generator %w(Task index --app_name MyApp)
    
    assert_file "#{javascripts_path}/controllers/tasks_controller.js.coffee" do |controller|
      controller_class = Regexp.escape("class MyApp.TasksController extends Batman.Controller")
      
      assert_match /#{controller_class}/, controller
      assert_match %r{  index: \(params\) ->}, controller
    end
  end
end
