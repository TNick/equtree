class  < ApplicationController
end
# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		The controller for user sheets
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

# the controller for user sheets
class SheetsController < ApplicationController
  

  # ----------------------------------------------------------------------
  # only allow a signed in user to create or destroy
  before_filter :signed_in_user

  # only allow correct user to destroy
  before_filter :correct_user,   only: :destroy
  
  # ======================================================================


  # ----------------------------------------------------------------------
  # Create the sheet
  def create
    @parent_dir = params[:parentdir]
    @sheet = @parent_dir.sheets.build( params[:sheet] )
    if @sheet.save
      flash[:success] = "Sheet created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end # def create
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Remove an user
  def destroy
    @sheet.destroy
    redirect_to root_url
  end # def destroy
  # ======================================================================


end # class SheetsController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
