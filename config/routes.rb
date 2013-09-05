TabSite::Application.routes.draw do
   
   #home page
   root 'static_pages#home'
   
   resources :sessions, only: [:create, :destroy]
   resources :users, execpt: [:index] #allows URL reflected user   
   
   ### Static Pages ###
   match '/about',    to: 'static_pages#about',    via: 'get'
   match '/contact',  to: 'static_pages#contact',  via: 'get'
   match '/sponsors', to: 'static_pages#sponsors', via: 'get'
   match '/test',     to: 'static_pages#test',     via: 'get'
   
   ### User Pages ###
   match '/signup',  to: 'users#new',           via: 'get'
end
