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
          file_type        = :javascript
          pattern          = /\/\/=(?!.*\/\/=).*?$/m

          unless exists?(application_file)
            application_file = "#{application_file}.coffee"
            file_type        = :coffeescript
            pattern          = /#=(?!.*#=).*?$/m
          end

          raise Thor::Error, "Couldn't find either application.js or application.js.coffee files for use with batman!" unless exists?(application_file)

          inject_into_file application_file, :before=>pattern do
            batman_requires(file_type)
          end

          inject_into_file application_file, :after=>pattern do
            ready_function(file_type)
          end
        end
      end

      private

      def ready_function(file_type=:javascript)
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

      def batman_requires(file_type=:javascript)
code = <<-CODE
\n// Batman.js and its adapters
//= require batman/es5-shim
//= require batman/batman
//= require batman/batman.jquery
//= require batman/batman.rails

//= require #{app_name}

//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./helpers
\n
CODE
        file_type == :coffeescript ? code.gsub('//', '#') : code
      end

      def exists?(file)
        File.exist?(File.join(destination_root, file))
      end
    end
  end
end
