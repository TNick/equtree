# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		The controller for user management
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

# the controller for user management
class UsersController < ApplicationController
  

  # ----------------------------------------------------------------------
  # only allow certain pages to a signed in user
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy]

  # only allow edit and update if the user is current user
  before_filter :correct_user,   only: [:edit, :update]

  # only the admin may destroy an user
  before_filter :admin_user,     only: :destroy
  # ======================================================================


  # ----------------------------------------------------------------------
  # View for creating a new user
  def new

    # ask the model to create a new entry that is provided to the view
    @user = User.new

  end # def new
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Profile page of the user
  def show

    # get the user to show from parameters
    @user = User.find(params[:id])

  end # def show
  # ======================================================================

  # ----------------------------------------------------------------------
  # Create the user
  def create

    # get the user
    @user = User.new( params[:user] )

    # attempt to save this user in our database
    if @user.save

      # if succesfull sign him in and go to his profile
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user

    else
      # failed to save; the User model has already set the error message
      render 'new'

    end

  end # def create
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # Edit user profile
  def edit
    
    # the user to edit from parameters
    @user = User.find( params[:id] )

  end # def edit
  # ======================================================================
  
  # ----------------------------------------------------------------------
  # User updated his/her profile
  def update

    # get the user from parameters
    @user = User.find(params[:id])

    # attempt to update the attributes
    if @user.update_attributes( params[:user] )

      # Handle a successful update; go to user profile page
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user

    # failed to update; error set by the model
    else

      render 'edit'

    end

  end # def update
  # ======================================================================

  # ----------------------------------------------------------------------
  # Page that lists all users
  def index

    @users = User.paginate( page: params[:page] )

  end # def index
  # ======================================================================

  # ----------------------------------------------------------------------
  # Remove an user
  def destroy

    # check that current is not being deleted
    crt_user = User.find( params[:id] )

    # locate the user
    del_user = User.find( params[:id] )

    # avoid admin deleting itself
    if ( crt_user == del_user )
      flash[:error] = "Can't delete current user"
      redirect_to( root_path )
    end

    # go delete from database
    del_user.destroy

    # show message for succes
    flash[:success] = "User destroyed."

    # and go back to list of users
    redirect_to users_url

  end # def destroy
  # ======================================================================

private
  
  # ----------------------------------------------------------------------
  # make sure that the user is the current user, otherwise leave
  def correct_user

    @user = User.find( params[:id] )
    redirect_to( root_path ) unless current_user?( @user )

  end
  # ======================================================================

  # ----------------------------------------------------------------------
  # make sure that the user is admin user, otherwise leave
  def admin_user

    redirect_to( root_path ) unless current_user.admin?

  end
  # ======================================================================


end # class UsersController

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
