class <%= js_app_name %>.<%= plural_name.camelize %>Controller extends Batman.Controller
<% actions.each do |action| -%>
  <%= action %>: (params) ->
    
<% end -%>
