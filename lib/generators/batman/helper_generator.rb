require 'generators/batman/common'
module Batman
  module Generators
    class HelperGenerator < ::Rails::Generators::NamedBase
      include Common

      desc "This generator creates a Batman helper"

      def create_batman_helper
        template "helper.coffee", "#{js_path}/helpers/#{plural_name.downcase}_helper.js.coffee"
      end
    end
  end
end
