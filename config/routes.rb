#map.connect ':controller/:action/:id'
ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:id/bioproj_members/:action', :controller => 'bioproj_members'
end