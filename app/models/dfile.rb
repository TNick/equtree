# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Code for a directory
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
 
# models the data associated with a directory
#
# == Schema Information
#
# Table name: dfiles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  directory_id  :integer
#  ftype         :integer
#  type_index    :integer
#  special_users :text
#  public_policy :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


class Dfile < ActiveRecord::Base
# TODO contemplate a new column: user; this would avoid going 
# through directory
  
  
  #
  #
  #
  #
  #  DEFINITIONS    -------------------------------------------------------
  
  
  # file types
  FTYPE_MIN = 0     # for validation; this is not a valid value
  FTYPE_TEST = 1    # testing type; has no associated table
  FTYPE_SHEET = 2   # mathematical sheet; handles by Sheet model
  FTYPE_MAX = 3     #  for validation; this is not a valid value
  
  # access types
  PP_PRIVATE = 0    # no access to others
  PP_MAYVIEW = 1    # others may view
  PP_MAYEDIT = 2    # others may view and edit
  
  #  DEFINITIONS    =======================================================
  #
  #
  #
  #
  #  ATTRIBUTES    --------------------------------------------------------
   
  
  # the list of attributes that are accesible for get/set
  attr_accessible :name, :ftype, :type_index, :special_users, :public_policy
  # :directory_id is not accesible
  # type_index is the index of the file in its dedicated table
  
 
  # any directory is part of an user
  belongs_to :directory
  
  # special users is an array of entries in form user_id - permission
  serialize :special_users#, :SpecialUsers
  
  #  ATTRIBUTES    ========================================================
  # 
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------

  # there must always be a name that is between 1 and 50 characters long
  validates :name,	presence: true, 
					length: { minimum: 1, maximum: 50 }

  # always have a valid type
  validates :ftype,	presence: true, 
					:numericality => { 
					  :greater_than => FTYPE_MIN, 
					  :less_than => FTYPE_MAX }
  
  # always have a valid association to a file in proper table
  #validates :type_index, presence: true # , 
                    #:numericality => { 
                    #  :greater_than => 0 }
  
  # always have an user
  validates :directory_id, 
                    presence: true


  #  VALIDATION    ========================================================
  #
  #
  #
  #
  #  MODIFIERS    ---------------------------------------------------------

  after_save :allocStorage
  around_destroy :releaseStorage
  
  #  MODIFIERS    =========================================================
  #
  #
  #
  #
  #  PUBLIC METHODS    ----------------------------------------------------

  # -----------------------------------------------------------------------
  # get the name of the type
  def typeName
    case ftype
    when FTYPE_TEST
      return 'test'
    when FTYPE_SHEET
      return 'mathsheet'
    else # 
      return 'generic'
    end
  end
  # =======================================================================
  
  # -----------------------------------------------------------------------
  # checks if this file is of sheet type; if so, returns the sheet, 
  # otherwise returns error
  def getSheet
    case ftype
    when FTYPE_SHEET
      return Sheet.find_by_id(type_index)
    else #  
      return nil
    end
  end
  # =======================================================================
 
  # -----------------------------------------------------------------------
  # get the owner of this file (will need to inspect the directory)
  def getUser ()
    return self.directory.user    
  end
  # =======================================================================
  
  # -----------------------------------------------------------------------
  # tell if provided user is allowed to view this file
  def mayView? ( other_user )
    if ( (not other_user.valid?) or ( other_user.is_a?(User) == false ) )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "basic check failed"
      # d other_user.type
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return false
    end
    user = getUser()
    if ( other_user == user )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "same user as owner"
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return true
    end
    if ( ( self.public_policy == Dfile::PP_MAYVIEW ) or ( self.public_policy == Dfile::PP_MAYEDIT ) )
      return true
    end
    if self.special_users
      special = self.special_users[other_user.id.to_s]
      if special
        if ( ( special == Dfile::PP_MAYVIEW ) or ( special == Dfile::PP_MAYEDIT ) )
          return true
        else
          # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          # d "User has special permission but not right one"
          # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"    
        end
      else
        # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # d "User has no special permission"
        # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"    
      end
      
    else
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "no special permissions"
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"    
    end
    return false
  end
  # =======================================================================
 
  # -----------------------------------------------------------------------
  # tell if provided user is allowed to edit this file
  def mayEdit? ( other_user )
    if ( (not other_user.valid?) or ( other_user.is_a?(User) == false ) )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "basic check failed"
      # d other_user.type
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return false
    end
    user = getUser()
    if ( other_user == user )
      return true
    end
    if ( ( self.public_policy == Dfile::PP_MAYEDIT ) )
      return true
    end
    if self.special_users
      special = self.special_users[other_user.id.to_s]
      if special
        if ( ( special == Dfile::PP_MAYEDIT ) )
          return true
        end
      end
    end
    return false
  end
  # =======================================================================
  
  # -----------------------------------------------------------------------
  # set special permissions for an user
  # returns true for success, false for failure
  def setPermission( other_user, perm )
    if ( (not other_user.valid?) or ( other_user.is_a?(User) == false ) )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "basic check failed"
      # d other_user.type
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return false
    end
    user = getUser()
    if ( other_user == user )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "same user as owner"
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return true
    end
    if not self.special_users
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "creating special users group"
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      self.special_users = {}
    end
    self.special_users[other_user.id.to_s] = perm
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "new permission:"
      # d self.special_users
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    return true
  end
  # =======================================================================
   
  # -----------------------------------------------------------------------
  # set special permissions for an user to view the file
  # returns true for success, false for failure
  def setPermissionView( other_user )
    return setPermission( other_user, Dfile::PP_MAYVIEW )
  end
  # =======================================================================
   
  # -----------------------------------------------------------------------
  # set special permissions for an user to edit the file
  # returns true for success, false for failure
  def setPermissionEdit( other_user )
    return setPermission( other_user, Dfile::PP_MAYEDIT )
  end
  # =======================================================================
  
   
  # -----------------------------------------------------------------------
  # remove special permissions for an user
  # returns true for success, false for failure
  def removePermission( other_user )
    if ( (not other_user.valid?) or ( other_user.is_a?(User) == false ) )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "basic check failed"
      # d other_user.type
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return false
    end
    user = self.getUser()
    if ( other_user == user )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "same user as owner"
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return false
    end
    if self.special_users
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "group before"
      # d self.special_users
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      self.special_users.delete( other_user.id.to_s )
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      # d "group after"
      # d self.special_users
      # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      return true
    end
    # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # d "The file has no special group"
    # d "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    return false
  end
  # =======================================================================
  
  
  #  PUBLIC METHODS    ====================================================
  #
  #
  #
  #
  #  PRIVATE HELPERS    ---------------------------------------------------

private

  # -----------------------------------------------------------------------
  def allocStorage
    # d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    # d "allocate storage for file"
    # d self.id
    # d "file type"
    # d self.ftype
    # d "type index"
    # d self.type_index
    # d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"    
    case self.ftype
    when FTYPE_SHEET
      if ( ( not self.type_index ) or ( self.type_index == -1 ) )
        sheet = Sheet.create( dfile_id: self.id )
        self.type_index = sheet.id
        self.save()
        # d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        # d "allocStorage: math sheet"
        # d sheet
        # d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"    
      end
    else
      self.type_index = -1
    end
    return true
  end
  # =======================================================================
  
  # -----------------------------------------------------------------------
  def releaseStorage
    # d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    # d "release storage for file"
    # d self.id
    # d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    
    case self.ftype
    when FTYPE_SHEET
      sheet = Sheet.find_by_id(self.type_index)
      if ( sheet )
        # d "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        # d "releaseStorage: math sheet"
        # d sheet
        # d "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
        # sheet.decRef()
        sheet.destroy
      end
    end
    return true
  end
  # =======================================================================

  #  PRIVATE HELPERS    ===================================================
  #
  #
  #
  #
  
end # class Dfile

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
