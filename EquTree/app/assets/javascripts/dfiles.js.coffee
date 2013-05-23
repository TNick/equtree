
# ========================================================================= 
# ------------------------------------------------------------------------- 
#!
#  \file            fs.js
#  \date            November 2012
#  \author        TNick
#
#  \brief        Functions that deal with file system tree
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
#  FUNCTIONS    ----------------------------------------------------------- 

# ------------------------------------------------------------------------- 
# ========================================================================= 

# ------------------------------------------------------------------------- 
@sheetInit = ->
  
  # redirect sheet toolbar to our handling function
  $("a[id^=tbsheet_]").click( ->
    sheetAction( this.id );
  )
  
  text_area = $('#equation_text')
  text_area.toolbar
    content: '#sheet_toolb'
    position: 'bottom'
    hideOnClick: true
  
  afterSheetLoad();
  
  
  
# ========================================================================= 


# ------------------------------------------------------------------------- 
@afterSheetLoad = ->
  all_equ = $(".equation")
  all_equ.draggable({ containment: $("#fs_content_file") })
  all_equ.click( ->
    inner_text = this.innerHTML
    inner_text.replace /\$\$/, ''
    $("#equation_text").val( inner_text )
    $("#equation_text").data( 'crt_equation', this.id )
  )
  $("#fs_content_file").data( 'crt_equ_id', 100 )
# ========================================================================= 

# ------------------------------------------------------------------------- 
@sheetAction = (action_id) ->
  action_id = action_id.replace /tbsheet_/, ''
  switch action_id
    when 'create_new'
      equ_text = $("#equation_text").val()
      if equ_text is ''
        alert "No content to add as a new equation"
        return
      # TODO parse input;
      # TODO engine specific markings
      
      crt_equ_id = $("#fs_content_file").data( 'crt_equ_id' )
      $("#fs_content_file").data( 'crt_equ_id', crt_equ_id+1 )
      $("#fs_file_zone").append('<div class="equation" id="equation_' + 
                                crt_equ_id + '">$$' + equ_text + '$$</div>')
      # TODO post to save in the database
      afterSheetLoad()
    when 'update'
      crt_equ_id = $("#equation_text").data( 'crt_equation' )
      console.log crt_equ_id
      if not crt_equ_id
        alert "There is no current equation"
        return
      crt_equ = $("#" + crt_equ_id)      
      if crt_equ.length == 0
        alert "There is no current equation"
        return
      
      equ_text = $("#equation_text").val()
      if equ_text is ''
        alert "No content to add to the equation"
        return
      # TODO parse input;
      # TODO engine specific markings
      crt_equ.html( '$$' + equ_text + '$$' );
    else
      fsError 'Coding error!'
      return

  
# ========================================================================= 

#  FUNCTIONS    =========================================================== 
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
