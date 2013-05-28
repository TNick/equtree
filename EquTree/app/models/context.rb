# == Schema Information
#
# Table name: contexts
#
#  id            :integer          not null, primary key
#  sheet_id      :integer
#  ancestry      :text
#  description   :text
#  info_uri      :text
#  position_left :float
#  position_top  :float
#  size_width    :float
#  size_height   :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

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
# Table name: expressions
#
#  id            :integer          not null, primary key
#  context_id    :integer
#  omath         :text
#  description   :text
#  info_uri      :text
#  position_left :float
#  position_top  :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Context < ActiveRecord::Base
  
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
  attr_accessible :description, :info_uri, :position_left, :position_top, :size_width, :size_height
  
  # any context is part of a sheet
  belongs_to :sheet
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------

  # the context should be valid
  validates :sheet_id,  presence: true
  
  # there must always be a position
  validates :position_left,  presence: true
  
  # there must always be a position
  validates :position_top,  presence: true
  
  # there must always be a size
  validates :size_width,  presence: true
  
  # there must always be a size
  validates :size_height,  presence: true
  
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
  
end # class Context

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
