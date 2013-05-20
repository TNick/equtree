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

FSTYPE_INVALID = -1
FSTYPE_DIR = 0
FSTYPE_FILE = 1


# the controller for user directories
class DirectoriesController < ApplicationController
  respond_to :json
  

  # ----------------------------------------------------------------------
  # only allow a signed in user to create or destroy
  before_filter :signed_in_user

  # only allow correct user to destroy
  before_filter :correct_user,   only: :destroy
  
  # ======================================================================


  # ----------------------------------------------------------------------
  # 
  def create
    
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
  
  # ----------------------------------------------------------------------
  # Remove a directory
  def destroy
    @directory.destroy
    redirect_to root_url
  end # def destroy
  # ======================================================================

private

  # ----------------------------------------------------------------------
  # Create a directory
  def create_directory
    d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d "create_directory"
    d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    
    pid = Integer( params[:sel_id] ) rescue pid = -1
    if pid <= 0
      pid = nil
    end
    @directory = current_user.directories.build( 
      name: params[:name],
      parent_id: pid
    )
    if @directory.save
      reponse = { action_id: params[:action_id],
                  new_id: @directory.id,
                  new_name: @directory.name,
                  parent_id: @directory.parent_id,
                  kind_name: 'directory'
                }
      render :json => reponse, :layout => false, :status => 200 and return
    else
      render json: @directory.errors, :layout => false, 
          status: :unprocessable_entity and return
    end
  end # def create_directory
  # ======================================================================

  # ----------------------------------------------------------------------
  # Create a file
  def create_file
    d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d "create_file"
    d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    
    parent_dir = Directory.find_by_id( params[:sel_id] )
    if !parent_dir
      render json: 'The directory does not exist', :layout => false, 
          status: :unprocessable_entity and return
    end
    d parent_dir
    d parent_dir.dfiles
    @dfile = parent_dir.dfiles.build(
      name: params[:name],
      ftype: params[:ftype]
    )
    d @dfile
    if !@dfile
      render json: @dfile.errors, :layout => false, 
          status: :unprocessable_entity and return
    end
    if @dfile.save
      reponse = { action_id: params[:action_id],
                  new_id: @dfile.id,
                  new_name: @dfile.name,
                  parent_id: @dfile.directory_id,
                  kind_name: @dfile.typeName()
                }
      render :json => reponse, :layout => false, :status => 200 and return
    else
      render json: @dfile.errors, :layout => false, 
          status: :unprocessable_entity and return
    end
    

  end # def create_file
  # ======================================================================

  # ----------------------------------------------------------------------
  # Rename a file or folder
  def rename_fs_item

    err_str = ''
    begin # a one time loop to allow break
    
      new_name = params[:name]
      if ( new_name.blank? )
        err_str = 'Empty name not allowed'
        break
      end
      
      generic_ty = Integer(params[:sel_kind]) rescue generic_ty = FSTYPE_INVALID
      elem_id = Integer(params[:sel_id]) rescue elem_id = -1
      if ( elem_id <= 0 )
        err_str = 'Invalid index'
        break
      end
      
      if ( generic_ty == FSTYPE_FILE )
        to_upd = Dfile.find_by_id( elem_id )
        if ( to_upd )
          to_upd.name = new_name
          if to_upd.save
            reponse = { action_id: params[:action_id],
                        new_id: to_upd.id,
                        new_name: to_upd.name,
                        parent_id: to_upd.directory_id,
                        kind_name: 'generic'
                      }
            render :json => reponse, :layout => false, :status => 200 and return
          else
            err_str = 'Failed to save file name'
            break
          end
        else
          err_str = 'File does not exist'
          break
        end
      elsif ( generic_ty == FSTYPE_DIR )
        to_upd = Directory.find_by_id( elem_id )
        if ( to_upd )
          to_upd.name = new_name
          if to_upd.save
            reponse = { action_id: params[:action_id],
                        new_id: to_upd.id,
                        new_name: to_upd.name,
                        parent_id: to_upd.parent_id,
                        kind_name: 'directory'
                      }
            render :json => reponse, :layout => false, :status => 200 and return
          else
            err_str = 'Failed to save directory'
            break
          end
        else
          err_str = 'Directory does not exist'
          break
        end
      else
        err_str = 'Invalid entry type'
        break
      end
    
    end until true # a one time loop to allow break
    render json: err_str, status: :unprocessable_entity and return
  end # def rename_fs_item
  # ======================================================================

  # ----------------------------------------------------------------------
  # Delete a file or folder
  def delete_fs_item
    d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d "Delete a file or folder"
    d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    
    err_str = ''
    begin # a one time loop to allow break
    
      generic_ty = Integer(params[:sel_kind]) rescue generic_ty = FSTYPE_INVALID
      elem_id = Integer(params[:sel_id]) rescue elem_id = -1
      if ( elem_id <= 0 )
        err_str = 'Invalid index'
        break
      end
      
      if ( generic_ty == FSTYPE_FILE )
        to_upd = Dfile.find_by_id( elem_id )
        if ( to_upd )
          kindname = to_upd.fileType()
          parent_id = to_upd.directory_id
          our_name = to_upd.name
          if to_upd.destroy
            reponse = { action_id: params[:action_id],
                        new_id: elem_id,
                        new_name: our_name,
                        parent_id: parent_id,
                        kind_name: kindname
                      }
            render :json => reponse, :layout => false, :status => 200 and return
          else
            err_str = 'Failed to delete file'
            break
          end
        else
          err_str = 'File does not exist'
          break
        end
      elsif ( generic_ty == FSTYPE_DIR )
        to_upd = Directory.find_by_id( elem_id )
        if ( to_upd )
          parent_id = to_upd.parent_id
          our_name = to_upd.name
          if to_upd.destroy
            reponse = { action_id: params[:action_id],
                        new_id: elem_id,
                        new_name: our_name,
                        parent_id: parent_id,
                        kind_name: 'directory'
                      }
            render :json => reponse, :layout => false, :status => 200 and return
          else
            err_str = 'Failed to delete directory'
            break
          end
        else
          err_str = 'Directory does not exist'
          break
        end
      else
        err_str = 'Invalid entry type'
        break
      end
    
    end until true # a one time loop to allow break
    render json: err_str, status: :unprocessable_entity and return
  end # def delete_fs_item
  # ======================================================================

  
  
end # class DirectoriesController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 

