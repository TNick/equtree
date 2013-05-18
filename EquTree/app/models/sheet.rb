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

# models the data associated with a sheet
#
# == Schema Information
#
# Table name: sheets
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  directory_id :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
#
class Sheet < ActiveRecord::Base
  
  #
  #
  #
  #
  #  DEFINITIONS    -------------------------------------------------------
  
  #  DEFINITIONS    =======================================================
  #
  #
  #
  #
  #  ATTRIBUTES    --------------------------------------------------------
   
  
  # the list of attributes that are accesible for get/set
  attr_accessible :name
  # :user_id is not accesible

  # any sheet is part of a directory
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

  # always have an user
  validates :directory_id, 
                    presence: true


  #  VALIDATION    ========================================================
  #
  #
  #
  #
  #  MODIFIERS    ---------------------------------------------------------

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
  
end # class Sheet

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
