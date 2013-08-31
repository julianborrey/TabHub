TabSite::Application.routes.draw do
   
   root 'static_pages#home'
   
   #resources :users #allows URL reflected user   
   
   #match '/signup',  to: 'users#new',           via: 'get'
end
