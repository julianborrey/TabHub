TabSite::Application.routes.draw do
   
  get "teams/new"
   #home page
   root 'static_pages#home'
   
   #resources for objects
   resources :sessions, only: [:new, :create, :destroy]
   resources :users, except: [:index] #allows URL reflected user   
   resources :institutions, except: [:index]
   resources :tournaments, except: [:index]
   resources :teams, except: [:index]

   ### Static Pages ###
   match '/about',    to: 'static_pages#about',    via: 'get'
   match '/contact',  to: 'static_pages#contact',  via: 'get'
   match '/sponsors', to: 'static_pages#sponsors', via: 'get'
   match '/test',     to: 'static_pages#test',     via: 'get'
   
   ### Session Pages ###
   match '/signin',   to: 'sessions#new',          via: 'get'
   match '/signout',  to: 'sessions#destroy',      via: 'delete'

   ### User Pages ###
   match '/signup',    to: 'users#new',            via: 'get'
   #^ this is just an additional path to it
   
   ### Tournament Offshoots ###
   match '/tournaments/:id/attendees', to: 'tournaments#attendees', via: 'get'
   
   #match '/pastmotions', to: 'static_pages#pastmotions', via: 'get'
end
