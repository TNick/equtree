# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		The controller for static pages
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

# the controller for static pages
class StaticPagesController < ApplicationController
  respond_to :html

  # ----------------------------------------------------------------------
  # Home page
  def home

    # have a directory ready if user decides to create one
    if signed_in?
      @directory = current_user.directories.build 
      @directories = current_user.directories.arrange(:order => :created_at)
    end
    #join_html_output
  end # def home
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Help page
  def help

    # stub; simply show the view in app/views/static_pages

  end # def help
  # ======================================================================

  # ----------------------------------------------------------------------
  # About page
  def about

    # stub; simply show the view in app/views/static_pages

  end # def about
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Contact page
  def contact

    # stub; simply show the view in app/views/static_pages

  end # def contact
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Todo page
  def todo

    # stub; simply show the view in app/views/static_pages

  end # def todo
  # ======================================================================
  
end # class StaticPagesController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
