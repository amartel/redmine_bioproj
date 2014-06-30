require 'redmine'
class BioprojApplicationHooks < Redmine::Hook::ViewListener
  
  render_on :view_layouts_base_html_head, :partial => 'bioproj/html_header'
    
end