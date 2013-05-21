class DfilesController < ApplicationController
end
# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date        May 2013
#  \author        TNick
#
#  \brief        The controller for user directories
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
  respond_to :json
  

  # ----------------------------------------------------------------------
  # only allow a signed in user to interact
  
  before_filter :signed_in_user
  
  # ======================================================================


  # ----------------------------------------------------------------------
  # 
  def act
    
    d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d params
    d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    b  = false
    case params[:action_id]
    when 'new_file'
      create_file
      b = true
    when 'new_dir'
      create_directory
      b = true
    when 'edit_name' 
      rename_fs_item
      b = true
    when 'cut'
      a = 1 # TODO
    when 'copy'
      a = 1 # TODO
    when 'paste'
      a = 1 # TODO
    when 'delete'
      delete_fs_item
      b = true
    when 'undo'
      a = 1 # TODO
    when 'redo'
      a = 1 # TODO
    else # 
      d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
      d "bad arguments"
      d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
      render json: 'Unknown function', status: :unprocessable_entity and return
    end
    if b
      return
    end
      
    d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d "Not implemented"
    d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    render json: 'Not implemented (yet)', status: :unprocessable_entity and return
    
  end # def create
  # ======================================================================
  

private

  # ----------------------------------------------------------------------
  # 
  def helper
 
  end # def helper
  # ======================================================================
  
  
end # class DirectoriesController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 

