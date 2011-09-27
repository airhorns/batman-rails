class <%= js_app_name %>.<%= singular_model_name %> extends Batman.Model
  @storageKey: '<%= plural_name %>'
  @persist Batman.RailsStorage

<% attributes.each do |attribute| -%>
  @encode <%= render_attribute(attribute) %>
<% end -%>
