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
  
  resources :sessions, only: [:new, :create, :destroy]
  
  #   HTTP Verb 	Path 		action 		used for
  #   ----------------------------------------------------
  #   GET 			/session/new 	new 		creating the session
  #   POST 			/session 		create 		create the new session
  #   DELETE 		/session 		destroy 	delete the session resource 
  
  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # create routes for directories
  resources :directories, only: [:create, :destroy]
  
  #   HTTP Verb 	Path 		action 		used for
  #   ----------------------------------------------------
  #   POST 			/directory 		create 		create the new directory
  #   DELETE 		/directory 		destroy 	delete the directory resource 
  
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
  
  # ======================================================================
  
  
  # ----------------------------------------------------------------------
  # other simple static pages
  
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  
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
