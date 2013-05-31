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
  has_one :context
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
  after_create :createResources
  
  #  MODIFIERS    =========================================================
  #
  #
  #
  #
  #  PUBLIC METHODS    ----------------------------------------------------
  
  # -----------------------------------------------------------------------
  # get associated context
  def mainContext
    # return Context.find( context )
    return context
  end
  # =======================================================================

  # -----------------------------------------------------------------------
  # returns the content of the instance as a hash, appropriate for sending 
  # to the client
  def to_hash ()
    
    ctx_list = []
    contexts.each do |ctx|
      ctx_list.push( ctx.to_hash() )
    end
    
    result = {
      contexts: ctx_list,
      root_context: context.id,
      dfile: dfile_id
    }

    return result
  end
  # =======================================================================
  
  # -----------------------------------------------------------------------
  # the description for the sheet is provided by the root context
  def description ()
    return context.description  
  end
  # =======================================================================
 
  #  PUBLIC METHODS    ====================================================
  #
  #
  #
  #
  #  PRIVATE HELPERS    ---------------------------------------------------

private

  # -----------------------------------------------------------------------
  def createResources
    if self.context.nil?
      self.context = self.contexts.create( 
        position_left: 0.0, position_top: 0.0, 
        size_width: 500.0, size_height: 500.0)
      self.save()
    end
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
