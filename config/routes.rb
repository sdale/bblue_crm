ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'contacts', :action => 'index'

  map.resources :contacts, :collection => {
                          :new_person => :get,
                          :new_company => :get,
                          :create_person => :post,
                          :create_company => :post
                          }

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
