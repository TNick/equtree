# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date        May 2013
#  \author      TNick
#
#  \brief       Code for a directory
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
# Table name: formulas
#
#  id         :integer          not null, primary key
#  omath      :text
#  descr      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sheet_id   :integer          not null
#
class Formula < ActiveRecord::Base
  
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
  attr_accessible :descr, :omath
  
  # any formula is part of a sheet
  belongs_to :sheet
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------


  # there must always be a name that is between 1 and 50 characters long
  validates :omath,  presence: true

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

  def toJSON
    result = {
        descr: descr,
        omath: omath
      }
    
  end
  
  
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
