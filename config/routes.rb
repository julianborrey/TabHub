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
   resources :tournament_attendees, only: [:create, :destroy, :update]
   resources :rooms, except: [:index, :destroy]
   resources :conflicts, only: [:create]
   
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
   
   match 'users/:id/tournaments', to: 'users#tournaments', via: 'get'

   ### Tournament Offshoots ###
   match '/tournaments/:id/control',        to: 'tournaments#control',            via: 'get'
   match '/tournaments/:id/attendees',      to: 'tournaments#attendees',          via: 'get' 
   match '/tournaments/:id/stats',          to: 'tournaments#stats',              via: 'get'
   match '/tournaments/:id/control/rounds', to: 'tournaments#rounds',             via: 'get'
   match '/tournaments/:id/control/institutions', to: 'tournaments#institutions', via: 'get'
   
   #room control
   match '/tournaments/:id/control/rooms',        to: 'tournaments#rooms',        via: 'get'
   match '/tournaments/:id/control/import-rooms', to: 'tournaments#import_rooms', via: 'get'
   match '/tournaments/:id/control/import-room',  to: 'tournaments#import_room',  via: 'post'
   match '/tournaments/:id/control/remove-room',  to: 'tournaments#remove_room',  via: 'post'
   
   #tabbie control
   match '/tournaments/:id/control/tab-room',        to: 'tournaments#tab_room',                          via: 'get'
   match '/tournaments/:id/control/tab-room',        to: 'tournament_attendees#create_tabbie_by_tabbie',  via: 'post'
   match '/tournaments/:id/control/tab-room/:ta_id', to: 'tournament_attendees#destroy_tabbie_by_tabbie', via: 'delete'

   #tournament adj control
   match '/tournaments/:id/control/adjudicators',             to: 'tournaments#adjudicators',                   via: 'get'
   match '/tournaments/:id/control/adjudicators',             to: 'tournament_attendees#create_adj_by_tabbie',  via: 'post'
   match '/tournaments/:id/control/adjudicators/:ta_id/edit', to: 'tournament_attendees#edit_adj_by_tabbie',    via: 'get'
   match '/tournaments/:id/control/adjudicators/:ta_id/edit', to: 'tournament_attendees#update_adj_by_tabbie',  via: 'post'
   match '/tournaments/:id/control/adjudicators/:ta_id/edit', to: 'tournament_attendees#destroy_adj_by_tabbie', via: 'delete'

   #conflicts control
   match '/tournaments/:id/control/adjudicators/:ta_id/conflicts', to: 'conflicts#create_by_tabbie', via: 'post'
   #no delete as of now
   
   #teams control
   match '/tournaments/:id/control/teams',          to: 'tournaments#teams',       via: 'get'
   match '/tournaments/:id/control/teams',          to: 'teams#create_by_tabbie',  via: 'post'
   match '/tournaments/:id/control/teams/:team_id', to: 'teams#destroy_by_tabbie', via: 'delete'

end
