require 'mocha'
require 'test_helper'
require 'generators/batman/install_generator'

module InstallGeneratorTests

  def setup
    mkdir_p "#{destination_root}/app/assets/javascripts"
    cp fixture(application_javascript_path), "#{destination_root}/app/assets/javascripts"
    Rails.application.class.stubs(:name).returns("Dummy::Application")
    super
  end
  
  def teardown
    Rails.application.class.unstub(:name)
  end

  def test_batman_application_file_is_created
    run_generator

    assert_file "#{javascripts_path}/dummy.js.coffee" do |app|
      assert_match /window\.Dummy = class Dummy extends Batman\.App/, app
      assert_match /@on 'ready', ->/, app
      assert_match /@on 'run', ->/, app
    end
  end

  def test_batman_application_file_is_created_for_two_word_application_name
    Rails.application.class.stubs(:name).returns("FooBar::Application")
    run_generator

    assert_file "#{javascripts_path}/foo_bar.js.coffee" do |app|
      assert_match /window\.FooBar = class FooBar extends Batman\.App/, app
    end
  end

  def test_application_require_is_properly_setup_for_two_word_application_name
    Rails.application.class.stubs(:name).returns("FooBar::Application")
    run_generator

    assert_file "#{javascripts_path}/#{application_javascript_path}", /require foo_bar/
  end

  def test_batman_directory_structure_is_created
    run_generator

    %W{controllers models helpers}.each do |dir|
      assert_directory "#{javascripts_path}/#{dir}"
      assert_file "#{javascripts_path}/#{dir}/.gitkeep"
    end
  end

  def test_no_gitkeep_files_are_created_when_skipping_git
    run_generator [destination_root, "--skip-git"]

    %W{controllers models helpers}.each do |dir|
      assert_directory "#{javascripts_path}/#{dir}"
      assert_no_file "#{javascripts_path}/#{dir}/.gitkeep"
    end
  end

  def test_applicationjs_require_batman_jquery_rails_and_dummy
    run_generator

    assert_file "#{javascripts_path}/#{application_javascript_path}" do |app|
      %W{batman batman.jquery batman.rails}.each do |require|
        assert_equal 1, app.scan(%r{require batman\/#{require}$}).length
      end

      assert_match /require dummy/, app

      %W{models controllers helpers}.each do |require|
        assert_equal 1, app.scan(/require_tree \.\/#{require}/).length
      end

      assert_equal 1, app.scan(/Dummy\.run\(\)/).length
    end
  end

  private

  def fixture(file)
    File.expand_path("fixtures/#{file}", File.dirname(__FILE__))
  end
end

class InstallGeneratorWithApplicationJavascriptTest < Rails::Generators::TestCase
  tests Batman::Generators::InstallGenerator

  def application_javascript_path
    "application.js"
  end

  include InstallGeneratorTests
end

class InstallGeneratorWithApplicationCoffeescriptTest < Rails::Generators::TestCase
  tests Batman::Generators::InstallGenerator

  def application_javascript_path
    "application.js.coffee"
  end

  include InstallGeneratorTests
end
