# See how all your routes lay out with "rake routes"
ActionController::Routing::Routes.draw do |map|
  map.resources :forums do |forum|
    forum.resources :topics, :member => {:add_comment => :post, :delete_comment => :delete}
  end
  
  map.resources :chatrooms, :member => {:accept => :put, :leave => :delete} do |chatroom|
    chatroom.resources :chats, :collection => {:refresh => :get, :refresh_status => :get}
  end

  map.resources :documents

  map.resources :messages,  
                   :collection => {:destroy_selected => :post,  
                                   :inbox            => :get,  
                                   :outbox           => :get,  
                                   :trashbin         => :get},  
                   :member => {:reply => :get}
                   
  map.resources :blogs, :member => {:add_comment => :post, :delete_comment => :delete}
  
  map.resources :events, :member => { :attend => :post, :unattend => :delete, :add_comment => :post, :delete_comment => :delete }

  map.resources :orders do |order|
    order.resources :order_progresses
  end
  
  # Non RESTful routes for user management.
  map.user_troubleshooting '/users/troubleshooting', :controller => 'users', :action => 'troubleshooting'
  map.user_forgot_password '/users/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.user_reset_password  '/users/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password'
  map.user_forgot_login    '/users/forgot_login',    :controller => 'users', :action => 'forgot_login'
  map.user_clueless        '/users/clueless',        :controller => 'users', :action => 'clueless'
  
  map.resources :users, :member => { :edit_password => :get,
                                     :update_password => :put,
                                     :edit_email => :get,
                                     :update_email => :put,
                                     :edit_avatar => :get, 
                                     :update_avatar => :put,
                                     :edit_time_zone => :get,
                                     :update_time_zone => :put },
                        :collection => {:refresh_activities => :get}
                            
  map.resource :session
  
  # Account shortcuts
  map.choose_lang '/choose_lang/:lang', :controller => 'users', :action => 'choose_lang'
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}
  
  # Profiles
  map.resources :profiles
  
  # Administration
  map.namespace(:admin) do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.resources :settings
    admin.resources :users, :member => { :suspend   => :put,
                                         :unsuspend => :put,
                                         :activate  => :put, 
                                         :purge     => :delete,
                                         :reset_password => :put,
                                         :choose_lang => :put },
                            :collection => { :pending   => :get,
                                             :active    => :get, 
                                             :suspended => :get, 
                                             :deleted   => :get }
    admin.resources :forums
  end
  
  # Dashboard as the default location
  map.root :controller => 'dashboard', :action => 'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
