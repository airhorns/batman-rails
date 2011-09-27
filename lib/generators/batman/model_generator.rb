require 'generators/batman/common'
module Batman
  module Generators
    class ModelGenerator < ::Rails::Generators::NamedBase
      include Common
      requires_app_name

      desc "This generator creates a Batman model"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_batman_model
        with_app_name do
          template "model.coffee", "#{js_path}/models/#{file_name.downcase}.js.coffee"
        end
      end

      protected
      def render_attribute(attribute)
        type = case attribute.type.to_s
        when 'date', 'datetime'
          "Batman.Encoders.railsDate"
        when 'string', 'integer', 'float', 'decimal', 'boolean', 'text'
        end

        ["'#{attribute.name}'", type].compact.join(', ')
      end
    end
  end
end
