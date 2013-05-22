# == Schema Information
#
# Table name: directories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#

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

# models the data associated with an directory
#
# == Schema Information
#
# Table name: directories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#
#
class Directory < ActiveRecord::Base
  
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
  attr_accessible :name, :parent_id
  # :user_id is not accesible

  # will be arranged in a tree
  has_ancestry

  # any directory is part of an user
  belongs_to :user
  
  # files are rooted here
  has_many :dfiles
  
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
  validates :user_id, 
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
  
end # class User

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
