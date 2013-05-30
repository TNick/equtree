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
#  imported_context_id    :integer
#  position_left :float
#  position_top  :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Import < ActiveRecord::Base
  
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
  attr_accessible :context_id, :imported_context_id, :position_left, :position_top
  
  
  # any import is part of a context
  belongs_to :context
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------

  # the parent context should be valid
  validates :context_id,  presence: true
  
  # the context that we're importing
  validates :imported_context_id,  presence: true
  
  # there must always be a position
  validates :position_left,  presence: true
  
  # there must always be a position
  validates :position_top,  presence: true
  
  
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
  # returns the content of the instance as a hash, appropriate for sending 
  # to the client
  def to_hash()
    result = {
        id: self.id,
        context_id: self.context_id,
        imported_context_id: self.imported_context_id,
        position_left: self.position_left,
        position_top: self.position_top
      }
    return result
  end # def to_hash
  # =======================================================================
  
private


  #  PRIVATE HELPERS    ===================================================
  #
  #
  #
  #
  
end # class Expression

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 

