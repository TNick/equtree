# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Contain stuff that benefits from being shared with all 
#               other controllers in the application
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

# this is a base class for all other controllers in the application
class ApplicationController < ActionController::Base
  
  # A feature in Rails that protects against Cross-site Request Forgery (CSRF) 
  # attacks. This feature makes all generated forms have a hidden id field. This id 
  # field must match the stored id or the form submission is not accepted. This 
  # prevents malicious forms on other sites or forms inserted with XSS from 
  # submitting to the Rails application.  
  protect_from_forgery
  
  
  # sign-in / sign-out facilities are exposed to all controllers
  include SessionsHelper
  
  
  # ----------------------------------------------------------------------
  # Force signout to prevent CSRF attacks
  def handle_unverified_request
	
	sign_out
	super
	
  end # def handle_unverified_request
  # ======================================================================
  
  
end # class ApplicationController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
