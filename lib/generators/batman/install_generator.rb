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
          application_file = File.join(js_path, "application.js")

          if File.exist?(File.join(destination_root, application_file))
            file_type = :javascript
            require_tree_pattern = /\/\/=(?!.*\/\/=).*?$/m
          else
            file_type = :coffeescript
            require_tree_pattern = /#=(?!.*\/\/=).*?$/m
            application_file = "#{application_file}.coffee"
            unless File.exist?(File.join(destination_root, application_file))
              raise Thor::Error, "Couldn't find either application.js or application.js.coffee files for use with batman!"
            end
          end

          inject_into_file application_file, :before=>require_tree_pattern do
code = <<-CODE
\n// Batman.js and its adapters
//= require batman/batman
//= require batman/batman.jquery
//= require batman/batman.rails

//= require #{app_name}

//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./helpers
\n
CODE
            if file_type == :coffeescript
              code.gsub!('//', '#')
            end
            code
          end

          inject_into_file application_file, :after=>require_tree_pattern do
            if file_type == :coffeescript
<<-CODE
\n# Run the Batman app
$(document).ready ->
  #{js_app_name}.run()
CODE
            else
<<-CODE
\n// Run the Batman app
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
end
