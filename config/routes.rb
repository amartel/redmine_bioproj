#map.connect ':controller/:action/:id'
match 'projects/:id/bioproj_members/:action', :controller => 'bioproj_members'
match 'projects/:id/bioproj/:action', :controller => 'bioproj'
