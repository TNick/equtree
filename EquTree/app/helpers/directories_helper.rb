# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Helper for user Directories
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

# helper module for Directories
module DirectoriesHelper
  
  # -----------------------------------------------------------------------
  # 
  def nested_directories(directories)
    if directories.nil?
      return "" 
    end
    a_ret = ""
    directories.map do |diriter,subdirectories|
      if diriter.nil? == false && diriter.name.nil? == false 
        a_ret = a_ret + 
             "<ul><li id=\"fs_edir_" + String(diriter.id) + "\" rel=\"directory\">" +
             "<a class=\"directory-entry\" href=\"\">"+ 
             diriter.name + "</a>\n"
        if subdirectories.nil? == false
          a_ret = a_ret + nested_directories(subdirectories)
        end
        diriter.dfiles.each do |dfile|
          a_ret = a_ret + 
          "<ul><li id=\"fs_efile_" + String(dfile.id) + "\" rel=\"" + dfile.typeName() + "\">" +
             "<a class=\"file-entry\" href=\"\">"+ 
             dfile.name + "</a></li></ul>\n"
        end
        a_ret = a_ret + "</li></ul>\n\n"
      end
    end
    return a_ret.html_safe
  end
  # =======================================================================
  
end # module DirectoriesHelper

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
