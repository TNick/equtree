

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
#  id          :integer          not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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
  attr_accessible :description
  
  # zero or more formulas in each sheet
  has_many :formulas
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------



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

  # -----------------------------------------------------------------------
  # convert the conent of this sheet to JSON
  def toJSON
    frm_ary = []
    formulas.each do |formula|
      frm_ary += formula.toJSON()
    end
    result = {
          description: description,
          formulas: frm_ary,
          file_type: 'mathsheet'
      }
    return result
  end
  # =======================================================================

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
