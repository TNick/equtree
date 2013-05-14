# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		The controller for sessions
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

# the controller for sessions
class SessionsController < ApplicationController
  

  # ----------------------------------------------------------------------
  # Creating a new session
  def new

    # stub

  end # def new
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Log in attempt
  def create

    # locate the user in our database
    user = User.find_by_email( params[:session][:email].downcase )

    # if the user exists and the password matches
    if user && user.authenticate( params[:session][:password] )

      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_back_or user

    # invalid log-in; show log-in page again with an error
    else

      flash.now[:error] = 'Invalid email/password combination'
      render 'new'

    end

  end # def create
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # signing out of a session; redirects to home page
  def destroy

    sign_out
    redirect_to root_url 

  end # def destroy
  # ======================================================================
  
  
end # class SessionsController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
