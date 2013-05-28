# == Schema Information
#
# Table name: sheets
#
#  id         :integer          not null, primary key
#  context_id :integer
#  dfile_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  before_create :allocStorage
  around_destroy :releaseStorage
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
  attr_accessible :context_id, :dfile_id
  
  belongs_to :dfile
  has_one :context
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------

  # don't check for the context; it gets created after the validation
  #validates :context_id, 
  #                  presence: true
  validates :dfile_id, 
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

  # -----------------------------------------------------------------------
  # get associated context
  def mainContext
    return Context.find( context_id )
  end
  # =======================================================================

  # -----------------------------------------------------------------------
  # convert the conent of this sheet to JSON
  def toJSON
    
    ctx = mainContext
    return ctx.toJSON()

    #frm_ary = []
    #formulas.each do |formula|
    #  frm_ary += formula.toJSON()
    #end
    #result = {
          #description: description,
          #formulas: frm_ary,
          #file_type: 'mathsheet'
    #  }
    #return result
  end
  # =======================================================================

private

  # -----------------------------------------------------------------------
  def allocStorage
    ctx = Context.create
    self.context_id = ctx.id
  end
  # =======================================================================
  
  # -----------------------------------------------------------------------
  def releaseStorage
    ctx = Context.find( self.context_id )
    ctx.destroy
  end
  # =======================================================================



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
