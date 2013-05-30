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
  attr_accessible :description, :parent_id, :info_uri, :position_left, :position_top, :size_width, :size_height
  
  # will be arranged in a tree
  has_ancestry
  
  # any context is part of a sheet
  belongs_to :sheet
  
  # expressions are rooted here
  has_many :expressions, :dependent => :delete_all
  
  # imports are rooted here
  has_many :imports, :dependent => :delete_all
  
  
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

  # -----------------------------------------------------------------------
  # returns the content of the instance as a hash, appropriate for sending 
  # to the client
  def to_hash ()
    
    kids_c = []
    self.children.each do |kid|
      kids_c.push( kid.to_hash() )
    end
    kids_e = []
    self.expressions.each do |kid|
      kids_e.push( kid.to_hash() )
    end
    kids_i = []
    self.imports.each do |kid|
      kids_i.push( kid.to_hash() )
    end
    
    result = {
        id: id,
        sheet_id: sheet_id,
        description: description,
        info_uri: info_uri,
        
        position_left: position_left,
        position_top: position_top, 
        size_width: size_width, 
        size_height: size_height,
        
        imports: kids_i, 
        expressions: kids_e,
        contexts: kids_c
      }
    return result
    
  end # def to_hash
  # =======================================================================
  
  # -----------------------------------------------------------------------
  def createSubContext
    return sheet.contexts.create parent_id: id
  end
  # =======================================================================
  
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
