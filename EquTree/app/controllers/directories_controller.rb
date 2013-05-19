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

FSTYPE_INVALID = -1
FSTYPE_DIR = 0
FSTYPE_FILE = 1


# the controller for user directories
class DirectoriesController < ApplicationController
  

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
    d { params }
	d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	
	case params[:action_id]
    when 'new_file'
      create_file
    when 'new_dir'
      create_directory
    when 'edit_name'
      rename_fs_item
    when 'cut'
      a = 1 # TODO
    when 'copy'
      a = 1 # TODO
    when 'paste'
      a = 1 # TODO
    when 'delete'
      delete_fs_item
    when 'undo'
	  a = 1 # TODO
	when 'redo'
	  a = 1 # TODO
    else # 
	  d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	  d { "bad arguments" }
	  d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
      redirect_to root_url
	end
    return
	
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
    d { "create_directory" }
	d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	
	pid = Integer( params[:sel_id] ) rescue pid = -1
	if pid <= 0
	  pid = nil
	end
	d { pid }
	@directory = current_user.directories.build( 
	  name: params[:name],
	  parent_id: pid
	)
    # $("<%= escape_javascript() %>").appendTo("#directory_tree");

	respond_to do |format|
	  if @directory.save
		#format.html { redirect_to root_url, notice: 'Directory was successfully created.' }
		#format.js   { render :action => 'create_dir' }
		format.json { render json: { 
		                            action_id: params[:action_id],
		                            new_id: @directory.id,
		                            new_name: @directory.name,
		                            parent_id: @directory.parent_id,
		                            kind_name: 'directory'
		                            },
		              status: :success }
	  else
		#format.html { 
		#  flash[:error] = "Directory creation failed!\n" 
		#  + @directory.errors.full_messages.join("\n") 
		#  redirect_to root_url
		#}
		format.json { render json: @directory.errors, status: :unprocessable_entity }
	  end
	end

	
  end # def create_directory
  # ======================================================================

  # ----------------------------------------------------------------------
  # Create a file
  def create_file
	d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d { "create_file" }
	d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	
	parent_dir = Directory.find( params[:sel_id] )
    @dfile = parent_dir.files.build(
	  name: params[:name],
	  type: params[:type]
	)
	# TODO implement
  end # def create_file
  # ======================================================================

  # ----------------------------------------------------------------------
  # Rename a file or folder
  def rename_fs_item
	d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d { "Rename a file or folder" }
	d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

	respond_to do |format|
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
		  to_upd = Dfile.find( elem_id )
		  if ( to_upd )
			to_upd.name = new_name
			if to_upd.save
			  format.json { render json: { 
										  action_id: params[:action_id],
										  new_id: to_upd.id,
										  new_name: to_upd.name,
										  parent_id: to_upd.directory_id,
										  kind_name: 'generic'
										  },
							status: :success }
			  return
			else
			  err_str = 'Failed to save file name'
			  break
			end
		  else
			err_str = 'File does not exist'
			break
		  end
		elsif ( generic_ty == FSTYPE_DIR )
		  to_upd = Directory.find( elem_id )
		  if ( to_upd )
			to_upd.name = new_name
			if to_upd.save
			  d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
			  d { "renaming ok" }
			  d { to_upd }
			  d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
			  format.json { render json: { 
										  action_id: params[:action_id],
										  new_id: to_upd.id,
										  new_name: to_upd.name,
										  parent_id: to_upd.parent_id,
										  kind_name: 'directory'
										  },
							status: :success }
			  return
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
	  d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	  d { "Error renaming" }
	  d { err_str }
	  d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	  format.json { render json: err_str, status: :unprocessable_entity }
	  return
	end # respond_to do |format|
	
  end # def rename_fs_item
  # ======================================================================

  # ----------------------------------------------------------------------
  # Delete a file or folder
  def delete_fs_item
	d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    d { "Delete a file or folder" }
	d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	
	
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
