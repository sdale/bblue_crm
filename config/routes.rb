ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'contacts', :action => 'index'

  map.resources :contacts
  map.resources :tasks
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
