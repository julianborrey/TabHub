TabSite::Application.routes.draw do
   
   #home page
   root 'static_pages#home'
   
   #resources for objects
   resources :sessions, only: [:new, :create, :destroy]
   resources :users, except: [:index] #allows URL reflected user   
   resources :institutions, except: [:index]
   resources :tournaments
   resources :teams, except: [:index]
   resources :rounds, except: [:index]
   resources :tournament_settings, only: [:create, :edit]
   resources :tournament_attendees, only: [:create, :destroy]
   resources :rooms, except: [:index]
   
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
   match '/tournaments/:id/control',              to: 'tournaments#control',   via: 'get'
   match '/tournaments/:id/attendees',            to: 'tournaments#attendees', via: 'get' 
   match '/tournaments/:id/stats',                to: 'tournaments#stats',     via: 'get'
   match '/tournaments/:id/control/tab-room',     to: 'tournaments#tab_room',  via: 'get'
   match '/tournaments/:id/control/rooms',        to: 'tournaments#rooms',     via: 'get'
   match '/tournaments/:id/control/import-rooms', to: 'tournaments#import_rooms', via: 'get'
   
   ### Rooms Custom Paths ###
   #match '/tournaments/:id/control/rooms/:room_id', to: 'rooms#show', via: 'get'
   #match '/tournaments/:id/control/rooms/:room_id/edit', to: 'rooms#edit', as: :edit_room, via: 'get'

   #match '/pastmotions', to: 'static_pages#pastmotions', via: 'get'
end
