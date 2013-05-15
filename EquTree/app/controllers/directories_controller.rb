# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		The controller for user directories
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

# the controller for user directories
class DirectoriesController < ApplicationController
  

  # ----------------------------------------------------------------------
  # only allow a signed in user to create or destroy
  before_filter :signed_in_user

  # only allow correct user to destroy
  before_filter :correct_user,   only: :destroy
  
  # ======================================================================


  # ----------------------------------------------------------------------
  # Create the directory
  def create
    @directory = current_user.directories.build(params[:directory])
    if @directory.save
      flash[:success] = "Directory created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end # def create
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Remove an user
  def destroy
    @directory.destroy
    redirect_to root_url
  end # def destroy
  # ======================================================================


end # class DirectoriesController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
