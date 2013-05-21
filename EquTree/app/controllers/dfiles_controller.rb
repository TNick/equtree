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
class DfilesController < ApplicationController
  respond_to :json
  

  # ----------------------------------------------------------------------
  # only allow a signed in user to interact
  
  before_filter :signed_in_user
  
  # ======================================================================


  # ----------------------------------------------------------------------
  # 
  def act
    
    d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d "act action on dfiles controller"
    d params
    d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    err_str = ''
    
    begin # a one time loop to allow break
      source_file_id = Integer( params[:source_file] ) rescue source_file = -1
      source_file = Dfile.find_by_id( source_file_id )
      if !source_file
        err_str = 'Invalid file ID: #{source_file_id}'
        break
      end
      
      case source_file.ftype
      when Dfile::FTYPE_SHEET
        sheet = Sheet.find_by_id( source_file.type_index )
        if !sheet
          err_str = 'Unknown file type'
          break
        end
        
        d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        d "good return; found sheet:"
        d sheet
        d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
        render json: sheet.toJson(), status: 200 and return
        
      else
        err_str = 'Unknown file type'
        break
      end
    end until true # a one time loop to allow break
    
    render json: err_str, status: :unprocessable_entity and return
    
    
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
  
  
end # class DfilesController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 

