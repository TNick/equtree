
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
getBox = ( elem, rel_to ) ->
  console.log 'getBox'
  el_off = elem.offset()
  console.log 'el_off',el_off
  width = elem.width()
  console.log 'width',width
  height = elem.height()
  console.log 'height',height
  r = new Rectangle()
  r.p1 = new Point2D( el_off.left - rel_to.x, el_off.top - rel_to.y )
  r.p2 = new Point2D( 
    r.p1.x + width, 
    r.p1.y + height
    )
  return r
# ========================================================================= 

# ------------------------------------------------------------------------- 
getBoxCenter = ( elem, rel_to ) ->
  console.log 'getBoxCenter'
  el_off = elem.offset()
  width = elem.width()
  height = elem.height()
  return new Point2D( 
    el_off.left + width/2 - rel_to.x, 
    el_off.top + height/2 - rel_to.y )
# ========================================================================= 

# ------------------------------------------------------------------------- 
getRectCenter = ( r ) ->
  console.log 'getRectCenter'
  return new Point2D( 
    (r.p1.x + r.p2.x)/2, 
    (r.p1.y + r.p2.y)/2 )
# ========================================================================= 

# ------------------------------------------------------------------------- 
getPos = ( elem ) ->
  console.log 'getPos'
  pos = elem.position()
  return new Point2D( pos.left, pos.top )
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
  $("#fs_file_zone").data( 'crt_path_id', 100 )
  createPath('equation_98','equation_99')
  
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

# ------------------------------------------------------------------------- 
@createPath = (eq_id_1,eq_id_2) ->

  # position of the parent
  file_zone = $("#fs_file_zone")
  fzpos = getPos( file_zone )
  console.log 'fzpos',fzpos
  
  # get the two equations
  eq_1 = $('#'+eq_id_1)
  eq_2 = $('#'+eq_id_2)
  if ( eq_1.length is not 1 ) or ( eq_1.length is not 1 )
    return ''
  # get the lists
  eq_1_list = eq_1.data( 'connections' )
  eq_2_list = eq_2.data( 'connections' )
  
  # check if there is already a path between them
  if eq_1_list
    if eq_1_list[eq_id_2] is not ''
      return eq_1_list[eq_id_2]
  else
    eq_1_list = {}
  if not eq_2_list
    eq_2_list = {}
  
  # get an ID for our new path
  path_id = file_zone.data( 'crt_path_id' )
  file_zone.data( 'crt_path_id', path_id+1 )
  
  # save the path in both equations
  eq_1_list[eq_id_2] = path_id
  eq_2_list[eq_id_1] = path_id
  eq_1.data( 'connections', eq_1_list )
  eq_2.data( 'connections', eq_2_list )
  
  r1 = getBox(eq_1,fzpos)
  r2 = getBox(eq_2,fzpos)
  console.log r1
  console.log r2
  
  #pt1 = getBoxCenter(eq_1,fzpos)
  #pt2 = getBoxCenter(eq_2,fzpos)
  pt1 = getRectCenter(r1)
  pt2 = getRectCenter(r2)
  console.log pt1
  console.log pt2
  
  l = new Line();
  l.p1 = pt1
  l.p2 = pt2
  console.log l
  
  i1 = Intersection.intersectLineRectangle(l.p1,l.p2,r1.p1,r1.p2)
  i2 = Intersection.intersectLineRectangle(l.p1,l.p2,r2.p1,r2.p2)
  console.log i1
  console.log i2
  console.log i1.points[0].x
  console.log i1.points[0].y
  console.log (i2.points[0].x-i1.points[0].x)
  console.log (i2.points[0].y-i1.points[0].y)
 
  if i1.points.length is 0 
    return ''
  if i2.points.length is 0 
    return ''  
  
  s_path = '<path d="M ' + i1.points[0].x + ' ' + i1.points[0].y + 
      ' l ' + (i2.points[0].x-i1.points[0].x) + ' ' + (i2.points[0].y-i1.points[0].y) + 
      '" stroke="green" stroke-width="3" fill="none" />'
  console.log s_path
  
  # insert the actual path element
  file_zone.append(
    '<svg class="equpath" id="' + path_id + '" xmlns="http://www.w3.org/2000/svg" version="1.1">' + 
      s_path +
    "</swg>")
  new_swg = $('#' + path_id)
  new_swg_css =
    position: 'absolute'
    top: fzpos.top + 'px'
    left: fzpos.left + 'px'
    width: Math.max(i1.points[0].x,i2.points[0].x)+1
    height: Math.max(i1.points[0].y,i2.points[0].y)+1
    'z-index': 9
    #marginLeft: 0
    #marginTop: 0
  console.log 'fzpos',fzpos
  new_swg.css( new_swg_css );
  console.log '------------------------------------------------------------------'
  console.log new_swg
  console.log jQuery.css( new_swg, name );
  console.log '------------------------------------------------------------------'
  
  return path_id
# ========================================================================= 

#  FUNCTIONS    =========================================================== 
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
