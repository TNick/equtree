# ========================================================================= 
# ------------------------------------------------------------------------- 
#!
#  \date          November 2012
#  \author        TNick
#
#  \brief         Support functions for dialogs
#
#
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
#  INCLUDES    ------------------------------------------------------------ 

#  INCLUDES    ============================================================ 
#
#
#
#
#  DEFINITIONS    --------------------------------------------------------- 

#  DEFINITIONS    ========================================================= 
#
#
#
#
#  DATA    ---------------------------------------------------------------- 



#  DATA    ================================================================ 
#
#
#
#
#  INTERNAL FUNCTIONS    --------------------------------------------------

# ------------------------------------------------------------------------- 
# close event for toolpanels is processed here
onToolpanelClose = ( event, ui ) ->
  the_dialog = $(this)
  
  # inform associated button that the dialog was closed
  assoc_toogle_id = the_dialog.data( 'assoc-btn' )
  if assoc_toogle_id
    the_name = assoc_toogle_id.replace 'btmbtn_',''
    assoc_toogle = $('#' + assoc_toogle_id)
    assoc_toogle.removeClass( 'bottom_btn_down' )
    jQuery.jCookie('bottombtn-dlg-'+the_name,'false')
# ========================================================================= 

# ------------------------------------------------------------------------- 
# drag end event for toolpanels is processed here
onToolpanelDragEnd = ( event, ui ) ->
  the_dialog = $(this)
  the_dialog_id = the_dialog.attr('id')
  jQuery.jCookie('bottombtn-dlg-posx-'+the_dialog_id, the_dialog.dialog().offset().left )
  jQuery.jCookie('bottombtn-dlg-posy-'+the_dialog_id, the_dialog.dialog().offset().top )

# ========================================================================= 

# ------------------------------------------------------------------------- 
# resize end event for toolpanels is processed here
onToolpanelResizeEnd = ( event, ui ) ->
  the_dialog = $(this)
  the_dialog_id = the_dialog.attr('id')
  jQuery.jCookie('bottombtn-dlg-sizex-'+the_dialog_id, the_dialog.dialog().width() )
  jQuery.jCookie('bottombtn-dlg-sizey-'+the_dialog_id, the_dialog.dialog().height() )

# ========================================================================= 
  
# ------------------------------------------------------------------------- 
# create a dialog
createToolPanel = ( the_name, pos_inside ) ->
  
  dlg_opts = 
    autoOpen: false
    closeOnEscape: true
    dialogClass: 'toolpanel'
    draggable: true
    hide: 'explode'
    modal: false
    resizable: true
    show: 'slow'
    title: the_name[0].toUpperCase() + the_name[1..-1]
    close: onToolpanelClose
    dragStop: onToolpanelDragEnd
    resizeStop: onToolpanelResizeEnd
    position:
      my: 'left top'
      at: pos_inside
    
  the_dialog_id = 'toolp_'+the_name
  the_dlg = $('#'+the_dialog_id).dialog( dlg_opts )
  the_dlg.data( 'assoc-btn', 'btmbtn_' + the_name )
  
  should_show = jQuery.jCookie( 'bottombtn-dlg-'+the_name )
  if should_show and should_show is 'true'
    toogleToolBtn(the_name)
  
  pos_x = jQuery.jCookie('bottombtn-dlg-posx-'+the_dialog_id)
  pos_y = jQuery.jCookie('bottombtn-dlg-posy-'+the_dialog_id)
  sz_x = jQuery.jCookie('bottombtn-dlg-sizex-'+the_dialog_id)
  sz_y = jQuery.jCookie('bottombtn-dlg-sizey-'+the_dialog_id)
  #console.log the_name, pos_x, pos_y
  #console.log the_name, sz_x, sz_y
  if pos_x and pos_y
    new_pos =
      my: "left top"
      at: ('left+' + pos_x + ' top+' + pos_y)
      of: $('body,html')
      #offset: pos_x + ' ' + pos_y
    the_dlg.dialog("option", "position", new_pos)
    #console.log new_pos
  if sz_x and sz_y
    the_dlg.dialog("option", "width", sz_x)
    the_dlg.dialog("option", "height", sz_y)
    
  return the_dlg

# ========================================================================= 

# ------------------------------------------------------------------------- 
# a click event on a toogle button
toogleToolBtn = ( the_name ) ->
  the_dlg = $('#toolp_'+the_name)
  the_btn = $('#btmbtn_'+the_name)
  if the_dlg.dialog('isOpen')
    the_dlg.dialog('close')
    the_btn.removeClass( 'bottom_btn_down' )
    jQuery.jCookie('bottombtn-dlg-'+the_name,'false')
  else
    the_dlg.dialog( 'open' )
    the_btn.addClass( 'bottom_btn_down' )
    jQuery.jCookie('bottombtn-dlg-'+the_name,'true')
# ========================================================================= 

#  INTERNAL FUNCTIONS    ==================================================
#
#
#
#
#  EXTERNAL FUNCTIONS    --------------------------------------------------



#  EXTERNAL FUNCTIONS    ==================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
