require 'generators/batman/common'
module Batman
  module Generators
    class ControllerGenerator < ::Rails::Generators::NamedBase
      include Common
      requires_app_name

      desc "This generator creates a Batman controller"
      argument :actions, :type => :array, :default => [], :banner => "action action"


      RESERVED_JS_WORDS = %w{
        break case catch continue debugger default delete do else finally for 
        function if in instanceof new return switch this throw try typeof var void while with 
      }

      def validate_no_reserved_words
        actions.each do |action|
          if RESERVED_JS_WORDS.include? action
             raise Thor::Error, "The name '#{action}' is reserved by javascript " <<
                                "Please choose an alternative action name and run this generator again."
          end
        end
      end

      def create_batman_controller
        with_app_name do
          template "controller.coffee", "#{js_path}/controllers/#{plural_name.downcase}_controller.js.coffee"
        end
      end
    end
  end
end
