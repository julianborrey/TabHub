TabSite::Application.routes.draw do
   
   #home page
   root 'static_pages#home'

   #devise user control
   devise_for(:users, controllers: { registrations: "users/registrations"})

   ######## Need to minimalize these! ######
   #resources for objects
   #resources :sessions, only: [:new, :create, :destroy]
   resources :users, except: [:index] #allows URL reflected user
   match '/users/:id/tournaments', to: 'users#tournaments', via: 'get'

   ### all of the resources ###
   resources :institutions, except: [:index]
   resources :tournaments
   resources :teams, except: [:index]
   resources :rounds, except: [:index]
   resources :tournament_settings, only: [:create, :edit]
   resources :tournament_attendees, only: [:create, :destroy, :update]
   resources :rooms, except: [:index, :destroy]
   resources :conflicts, only: [:create]
   resources :room_draws, except: [:show, :index]
  	
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
   
   #match 'users/:id/tournaments', to: 'users#tournaments', via: 'get'

   ### Tournament Offshoots ###
   match '/tournaments/:id/control',        to: 'tournaments#control',                via: 'get'
   match '/tournaments/:id/attendees',      to: 'tournaments#attendees',              via: 'get' 
   match '/tournaments/:id/stats',          to: 'tournaments#stats',                  via: 'get'
   match '/tournaments/:id/control/rounds', to: 'tournaments#rounds',                 via: 'get'
   match '/tournaments/:id/control/draw',   to: 'tournaments#draw',                   via: 'get'
   
   ### Tournament State Controls ###
   match '/tournaments/:id/control/registration/open',  to: 'tournaments#open_rego',  via: 'post'
   match '/tournaments/:id/control/registration/close', to: 'tournaments#close_rego', via: 'post'
   match '/tournaments/:id/control/start/', 				  to: 'tournaments#start_tournament', via: 'post'
   match '/tournaments/:id/control/close/', 				  to: 'tournaments#close_tournament', via: 'post'

   ### Round State Controls ###
   match '/tournaments/:id/rounds/make-next-draw',  to: 'rounds#make_draw',  		    via: 'post'
   match '/tournaments/:id/rounds/progress',        to: 'rounds#make_draw_progress', via: 'get'
   match '/tournaments/:id/rounds/:round_num/draw', to: 'rounds#show_draw',          via: 'get'
   match '/tournaments/:id/rounds/release-draw',    to: 'rounds#release_draw',		 via: 'post'
   match '/tournaments/:id/rounds/start-round/',    to: 'rounds#start_round', 	    via: 'post'

   #handling user registration
   match '/tournaments/:id/registration/individual', to: 'tournaments#individual', via: 'get'

   #institution control
   match '/tournaments/:id/control/institutions',              to: 'tournaments#institutions',        via: 'get'
   match '/tournaments/:id/control/institutions',              to: 'allocations#allocate_by_tabbie',  via: 'post'
   match '/tournaments/:id/control/institution/:inst_id',      to: 'institutions#show_for_tabbie',     via: 'get'
   match '/tournaments/:id/control/institution/:inst_id/edit', to: 'allocations#edit_by_tabbite',     via: 'get'
   match '/tournaments/:id/control/institution/:inst_id/edit', to: 'allocations#update_by_tabbie',    via: 'post'
   match '/tournaments/:id/control/institution/:inst_id',      to: 'tournament#kick_from_tournament', via: 'delete'
   
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
   match '/tournaments/:id/control/adjudicators',             to: 'tournament_attendees#create_adj_by_tabbie_or_user',  via: 'post'
   match '/tournaments/:id/control/adjudicators/:ta_id/edit', to: 'tournament_attendees#edit_adj_by_tabbie',    via: 'get'
   match '/tournaments/:id/control/adjudicators/:ta_id/edit', to: 'tournament_attendees#update_adj_by_tabbie',  via: 'post'
   match '/tournaments/:id/control/adjudicators/:ta_id/edit', to: 'tournament_attendees#destroy_adj_by_tabbie_or_user', via: 'delete'

   #conflicts control
   match '/tournaments/:id/control/adjudicators/:ta_id/conflicts', to: 'conflicts#create_by_tabbie', via: 'post'
   #no delete as of now
   
   #teams control
   match '/tournaments/:id/control/teams',          to: 'tournaments#teams',               via: 'get'
   match '/tournaments/:id/control/teams',          to: 'teams#create_by_tabbie_or_user',  via: 'post'
   match '/tournaments/:id/control/teams/:team_id', to: 'teams#destroy_by_tabbie_or_user', via: 'delete'
   
   #custom error pages
   match '/404' => "errors#not_found",    via: 'get'
   match '/500' => "errors#server_error", via: 'get'

   #illegal access pages
   match '/errors/illegal-access/:page' => 'errors#illegal_access', via: 'get'
end
