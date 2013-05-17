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
    
    parent_el_nr = params[:dir_selectedid].gsub(/dir_leaf_/,'')
    has_parent_el = Integer(parent_el_nr) > 0 rescue false
    if ( has_parent_el )
      parent_dir = Directory.find( parent_el_nr )
      params[:directory][:parent_id] = parent_dir
    end

    if ( params[:fstype] == "dir" )
      manage_dir(has_parent_el,parent_dir)
    elsif ( params[:fstype] == "file" )
      manage_file(has_parent_el,parent_dir)
    else
        flash[:error] = "Internal error!"
    end

    redirect_to root_url

  end # def create
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Remove an user
  def destroy
    @directory.destroy
    redirect_to root_url
  end # def destroy
  # ======================================================================

private

  # ----------------------------------------------------------------------
  # Create top-level directory or leaf directory
  def create_all_level_dir
      @directory = current_user.directories.build( params[:directory] )
      if @directory.save
        flash[:success] = "Directory created!"
      else
        flash[:error] = "Subdirectory creation failed!\n" + @directory.errors.full_messages.join("\n")
      end
  end # def destroy
  # ======================================================================

  # ----------------------------------------------------------------------
  # Do directory related tasks
  def manage_dir(has_parent_el,parent_dir)

    if ( params[:top] )
      create_all_level_dir
    elsif ( params[:create] )
      create_all_level_dir
    elsif ( params[:del] )
      if ( has_parent_el )
        parent_dir.destroy
      else
        flash[:error] = "No entry selected!"
      end
    elsif ( params[:chg] )
      if ( has_parent_el )
         parent_dir.name = params[:directory][:name]
         if parent_dir.save
           flash[:success] = "Entry updated!"
         else
           flash[:error] = "Failed to update entry!"
         end
      else
        flash[:error] = "No entry selected!"
      end
    else
        flash[:error] = "Internal error!"
    end

  end # def manage_dir
  # ======================================================================

  # ----------------------------------------------------------------------
  # Create top-level directory or leaf directory
  def create_all_level_file(has_parent_el,parent_dir)
    
    if ( has_parent_el == false )
      flash[:error] = "Can't create file at top level! Please select a directory."
      return
    end



  end # def create_all_level_file
  # ======================================================================

  # ----------------------------------------------------------------------
  # Do file related tasks
  def manage_file(has_parent_el,parent_dir)
    
    if ( params[:top] )
      create_all_level_file(has_parent_el,parent_dir)
    elsif ( params[:create] )
      create_all_level_file(has_parent_el,parent_dir)
    elsif ( params[:del] )
      
    elsif ( params[:chg] )
      
    else
        flash[:error] = "Internal error!"
    end

  end # def manage_file
  # ======================================================================



end # class DirectoriesController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
