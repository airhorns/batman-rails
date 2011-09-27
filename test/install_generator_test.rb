require 'mocha'
require 'test_helper'
require 'generators/batman/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Batman::Generators::InstallGenerator
  
  def setup
    mkdir_p "#{destination_root}/app/assets/javascripts"
    cp fixture("application.js"), "#{destination_root}/app/assets/javascripts"
    Rails.application.class.stubs(:name).returns("Dummy::Application")
    
    super
  end
  
  test "Assert Batman application file is created" do
    run_generator
    
    assert_file "#{javascripts_path}/dummy.js.coffee" do |app|
      assert_match /window\.Dummy = class Dummy extends Batman\.App/, app
      assert_match /@run ->/, app
    end
  end
  
  test "Assert Batman application file is created for two word application name" do
    Rails.application.class.stubs(:name).returns("FooBar::Application")
    run_generator
    
    assert_file "#{javascripts_path}/foo_bar.js.coffee" do |app|
      assert_match /window\.FooBar = class FooBar extends Batman\.App/, app
    end
  end
  
  test "Assert application require is properly setup for two word application name" do
    Rails.application.class.stubs(:name).returns("FooBar::Application")
    run_generator
    
    assert_file "#{javascripts_path}/application.js", /require foo_bar/
  end
  
  test "Assert Batman directory structure is created" do
    run_generator
    
    %W{controllers models helpers}.each do |dir|
      assert_directory "#{javascripts_path}/#{dir}"
      assert_file "#{javascripts_path}/#{dir}/.gitkeep"
    end
  end
  
  test "Assert no gitkeep files are created when skipping git" do
    run_generator [destination_root, "--skip-git"]
    
    %W{controllers models helpers}.each do |dir|
      assert_directory "#{javascripts_path}/#{dir}"
      assert_no_file "#{javascripts_path}/#{dir}/.gitkeep"
    end
  end
  
  test "Assert application.js require batman, batman.jquery, batman.rails and dummy.js" do
    run_generator
    
    assert_file "#{javascripts_path}/application.js" do |app|
      %W{batman batman.jquery batman.rails}.each do |require|
        assert_match /require batman\/#{require}/, app
      end

      assert_match /require dummy/, app

      %W{models controllers helpers}.each do |require|
        assert_match /require_tree \.\/#{require}/, app
      end

      assert_match /Dummy\.run\(\)/, app
    end
  end

  private

  def fixture(file)
    File.expand_path("fixtures/#{file}", File.dirname(__FILE__))
  end
end
