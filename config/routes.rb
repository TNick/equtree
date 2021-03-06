# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		The Rails router recognizes URLs and dispatches them 
#               to a controller’s action. It can also generate paths and 
#               URLs, avoiding the need to hardcode strings in views.
#
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Please read COPYING and README files in root folder
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# get    "widgets"          => "widgets#index",   :as => 'widgets'
# get    "widgets/:id"      => "widgets#show",    :as => 'widget'
# get    "widgets/new"      => "widgets#new",     :as => 'new_widget'
# post   "widgets"          => "widgets#create",  :as => 'widgets'
# get    "widgets/:id/edit" => "widgets#edit",    :as => 'edit_widget'
# put    "widgets/:id"      => "widgets#update",  :as => 'widget'
# delete "widgets/:id"      => "widgets#destroy", :as => 'widget'
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
#
#
#
#
#  ROUTES    -------------------------------------------------------------

EquTree::Application.routes.draw do
  
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  # ----------------------------------------------------------------------
  # create all routes for users
  
  resources :users
  
  #   HTTP Verb 	Path 		action 		used for
  #   ----------------------------------------------------
  #   GET 			/user/new 	new 		return an HTML form for creating the user
  #   POST 			/user 		create 		create the new user
  #   GET 			/user 		show 		display the one and only user resource
  #   GET 			/user/edit 	edit 		return an HTML form for editing the user
  #   PUT 			/user 		update 		update the one and only user resource
  #   DELETE 		/user 		destroy 	delete the user resource 
  
  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # create routes for session
  
  resources :sessions, only: [:create, :destroy]
  
  #   HTTP Verb 	Path 		action 		used for
  #   ----------------------------------------------------
  #   POST 			/session 		create 		create the new session
  #   DELETE 		/session 		destroy 	delete the session resource 
  
  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # create routes for directories
  resources :directories, only: [:create] # , :destroy
  
  #   HTTP Verb 	Path 		action 		used for
  #   ----------------------------------------------------
  #   POST 			/directory 	create 		create the new directory
  #   DELETE 		/directory 	destroy 	delete the directory resource 
  
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # create routes for files
  #resources :dfiles, only: [:act]
  match 'files' => 'dfiles#act', :method => :post
  
  #   HTTP Verb 	Path 		action 		used for
  #   ----------------------------------------------------
  #   POST 			/file 		act 		all actions
  
  # ======================================================================

  # ----------------------------------------------------------------------
  # both default and /home go to our home page

  root to: 'static_pages#home'
  match '/home', to: 'static_pages#home'
  
  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # other simple static pages
  
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/todo',    to: 'static_pages#todo'
  
  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # other simple static pages
  
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  
  #   HTTP Verb 	Path 		Route			Action 		Used for...
  #   -------------------------------------------------------------------------------------
  #   GET			/signin		signin_path		new			page for a new session (signin)
  #   POST			/sessions	sessions_path	create		create a new session
  #   DELETE		/signout	signout_path	destroy		delete a session (sign out)

  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # signing out is done using an HTTP DELETE request

  match '/signout', to: 'sessions#destroy', via: :delete
  
  # ======================================================================
  
  
end # EquTree::Application.routes.draw

#  ROUTES    =============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
