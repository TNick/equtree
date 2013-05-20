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
# Table name: directories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  directory_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Dfile < ActiveRecord::Base
  
  #
  #
  #
  #
  #  DEFINITIONS    -------------------------------------------------------
  
  FTYPE_MIN = 0
  FTYPE_TEST = 1
  FTYPE_SHEET = 2
  FTYPE_MAX = 3
  
  #  DEFINITIONS    =======================================================
  #
  #
  #
  #
  #  ATTRIBUTES    --------------------------------------------------------
   
  
  # the list of attributes that are accesible for get/set
  attr_accessible :name, :ftype
  # :directory_id is not accesible

  # any directory is part of an user
  belongs_to :directory
  
  
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

  # always have an user
  validates :directory_id, 
                    presence: true


  #  VALIDATION    ========================================================
  #
  #
  #
  #
  #  MODIFIERS    ---------------------------------------------------------

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
  
  #  MODIFIERS    =========================================================
  #
  #
  #
  #
  #  PRIVATE HELPERS    ---------------------------------------------------

private


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
