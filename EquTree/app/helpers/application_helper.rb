# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Helper code available in Views/Helpers; may be explicitly
#               included in other places
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

# helper module with things available to the whole application
module ApplicationHelper
  
  
  # ----------------------------------------------------------------------
  # Returns the full title on a per-page basis.
  # \param page_title	the title as defined in the page or nil
  # \return the string to use as title
  def full_title			( page_title )
	
	base_title = "EquTree"
	
	# if the page defines no title just use the name of the application
	if page_title.empty?
	  base_title
	else
	  "#{base_title} | #{page_title}"
	end
	
  end
  # ======================================================================
  
  
end # module ApplicationHelper

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
