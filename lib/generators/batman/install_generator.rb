require 'generators/batman/common'
module Batman
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Common
      requires_app_name

      desc "This generator installs Batman.js with a default folder layout"

      class_option :skip_git, :type => :boolean, :aliases => "-G", :default => false,
                              :desc => "Skip Git ignores and keeps"

      def create_batman_app
        with_app_name do
          template "batman_app.coffee", "#{js_path}/#{app_name}.js.coffee"
        end
      end

      def create_directories
        %w(models controllers helpers).each do |dir|
          empty_directory "#{js_path}/#{dir}"
          create_file "#{js_path}/#{dir}/.gitkeep" unless options[:skip_git]
        end
      end

      def inject_batman
        with_app_name do
          inject_into_file "#{js_path}/application.js", :after=>/\/\/=(?!.*\/\/=).*?$/m do
<<-CODE
\n\n//= require batman/batman
//= require batman/batman.jquery
//= require batman/batman.rails

//= require #{app_name}

//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./helpers

$(document).ready(function(){
  #{js_app_name}.run();
});
CODE
          end
        end
      end
    end
  end
end
