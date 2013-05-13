# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Helper for sessions
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
#  CLASS    ---------------------------------------------------------------

# helper module for session related topics
module SessionsHelper
  
  # ----------------------------------------------------------------------
  # signs in current user (cookie and variable)
  def sign_in			( user )
	
	# save provided user in cookie
    cookies.permanent[:remember_token] = user.remember_token
    # cookies[:remember_token] = { value:   user.remember_token,
    #                         expires: 20.years.from_now.utc }
	
	# and set current user in a variable
    self.current_user = user
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # signs out current user (cookie and variable)
  def sign_out
	
	# clear current variable
    self.current_user = nil
	
	# clear value from cookie
    cookies.delete(:remember_token)
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # tells if there is an user signed in based on internal variable
  # \return true if there is an user signed in
  def signed_in?
    !current_user.nil?
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # sets current user
  def current_user=			( user )
    @current_user = user
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # reads the user from cookie if not already set
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # tell if an user is the current user
  # \return true if it is
  def current_user?			( user )
	user == current_user
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # checks if the user is signed in; if is not stores the location and
  # redirects to the Sign-In page; when the user will complete that
  # step it will be moved to requested page
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to( signin_url, notice: "Please sign in." )
    end
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # if the session has a return location set (like store_location() does) 
  # then that path is followed. otherwise the default one is taken
  def redirect_back_or		( default )
	
    redirect_to( session[:return_to] || default )
    session.delete( :return_to )
	
  end
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # stores requested uri in a session variable for future use 
  # \see redirect_back_or()
  def store_location
    session[:return_to] = request.url
  end
  # ======================================================================
  
  
end # module SessionsHelper

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
