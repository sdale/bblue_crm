ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'users', :action => 'index'

  map.resources :contacts
  map.resources :tasks
  map.resources :deals
  
  map.resources :users, :collection => {:login => [:get,:post], :logoff => :get}
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
