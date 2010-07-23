ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'users', :action => 'index'

  map.resources :contacts, :member => {:convert => :get}
  map.resources :todos
  map.resources :deals
  
  map.resources :users, :collection => {:login => [:get,:post], :logoff => :get}
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
