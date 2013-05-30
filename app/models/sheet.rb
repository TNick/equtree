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
#  id         :integer          not null, primary key
#  context    :integer
#  dfile_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  attr_accessible :context, :dfile_id
  
  # associated with a file
  belongs_to :dfile
  
  # master context is embedded here
  #has_one :context, :dependent => :destroy
  has_many :contexts, dependent: :delete_all
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------

  # don't check for the context; it gets created after the validation
  #validates :context, 
  #                  presence: true
  validates :dfile_id, 
                    presence: true

  #  VALIDATION    ========================================================
  #
  #
  #
  #
  #  MODIFIERS    ---------------------------------------------------------
  
  # create master context
  before_create :createResources
  
  #  MODIFIERS    =========================================================
  #
  #
  #
  #
  #  PRIVATE HELPERS    ---------------------------------------------------

  # -----------------------------------------------------------------------
  # get associated context
  def mainContext
    return Context.find( context )
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
  def createResources
    self.context = create_context( 
      position_left: 0.0, position_top: 0.0, 
      size_width: 50.0, size_height: 50.0)
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
