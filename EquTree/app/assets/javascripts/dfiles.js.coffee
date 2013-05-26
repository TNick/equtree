# ========================================================================= 
# ------------------------------------------------------------------------- 
#!
#  \file          fs.js
#  \date          November 2012
#  \author        TNick
#
#  \brief         Functions that deal with file system tree
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
# gets the bounding box of an element $('#element') as a Rectangle
getBox = ( elem, rel_to ) ->
  # console.log 'getBox'
  el_off = elem.offset()
  # console.log 'el_off',el_off
  width = elem[0].offsetWidth # elem.width()
  # console.log 'width',width
  height = elem[0].offsetHeight # lem.height()
  # console.log 'height',height
  r = new Rectangle()
  r.p1 = new Point2D( el_off.left - rel_to.x, el_off.top - rel_to.y )
  r.p2 = new Point2D( 
    r.p1.x + width, 
    r.p1.y + height
    )
  return r
# ========================================================================= 

# ------------------------------------------------------------------------- 
# computes the position of the center of an element $('#element') as 
# a Point2D; the computed point is relative to rel_to point
getBoxCenter = ( elem, rel_to ) ->
  el_off = elem.offset()
  width = elem.offsetWidth # elem.width()
  height = elem.offsetHeight # elem.height()
  return new Point2D( 
    el_off.left + width/2 - rel_to.x, 
    el_off.top + height/2 - rel_to.y )
# ========================================================================= 

# ------------------------------------------------------------------------- 
# computes the position of a rectangle as a Point2D
getRectCenter = ( r ) ->
  return new Point2D( 
    (r.p1.x + r.p2.x)/2, 
    (r.p1.y + r.p2.y)/2 )
# ========================================================================= 

# ------------------------------------------------------------------------- 
# computes the position of an element $('#element') as a Point2D
getPos = ( elem ) ->
  pos = elem.position()
  return new Point2D( pos.left, pos.top )
# ========================================================================= 

# ------------------------------------------------------------------------- 
# computes the line that joins the center of two rectangles, trimmed to
# those rectangles; it returns null if the two rectangles overlap
getJoinLine = ( r1, r2 ) ->
  pt1 = getRectCenter(r1)
  pt2 = getRectCenter(r2)

  i1 = Intersection.intersectLineRectangle( pt1, pt2, r1.p1, r1.p2 )
  i2 = Intersection.intersectLineRectangle( pt1, pt2, r2.p1, r2.p2 )
  if i1.points.length is 0 
    return null
  if i2.points.length is 0 
    return null
  if i1.points[0] is i2.points[0]
    return null
  l = new Line()
  l.p1 = i1.points[0]
  l.p2 = i2.points[0]
  return l
# ========================================================================= 

# ------------------------------------------------------------------------- 
# computes the line that joins the center of two elements, trimmed to
# those bounding boxes; it returns null if the two rectangles overlap
# fzpos is the position of the origin
lineBetweenExpr = ( eq_1, eq_2, fzpos ) ->
  r1 = getBox(eq_1,fzpos)
  r2 = getBox(eq_2,fzpos)
  return getJoinLine( r1, r2 )
# ========================================================================= 

# ------------------------------------------------------------------------- 
# updates the path with the new line
# fzpos is the position of the origin
updatePath = ( the_path_swg, new_line, fzpos  ) ->
  the_path = the_path_swg.children().get(0)
  new_swg_css =
    position: 'absolute'
    top: 0 # fzpos.y + 'px'
    left: 0 # fzpos.x + 'px'
    width: Math.max(new_line.p1.x,new_line.p2.x)+1
    height: Math.max(new_line.p1.y,new_line.p2.y)+1
  the_path_swg.css( new_swg_css )
  s_path = 'M ' + new_line.p1.x + ' ' + new_line.p1.y + 
           ' l '  + (new_line.p2.x-new_line.p1.x) + ' ' + 
           (new_line.p2.y-new_line.p1.y)
  the_path.setAttribute( 'd', s_path )
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# creates a new path
# file_zone is where the new path is placed
# the new path is saved inside the connection list for each expression
createNewPath = (file_zone, eq_1, eq_2) ->
  
  # get an ID for our new path
  path_id = file_zone.data( 'crt_path_id' )
  file_zone.data( 'crt_path_id', path_id+1 )
  path_id = 'interexpr_' + path_id
  
  # insert the actual path element
  file_zone.prepend(
    '<svg class="exprpath" id="' + path_id + '" xmlns="http://www.w3.org/2000/svg" version="1.1">' + 
      '<path stroke="green" stroke-width="3" fill="none" />' +
    "</swg>")
  
  # get the lists
  eq_1_list = eq_1.data( 'connections' )
  eq_2_list = eq_2.data( 'connections' )
  # save the path in both expressions
  eq_1_list[eq_2.attr('id')] = path_id
  eq_2_list[eq_1.attr('id')] = path_id
  eq_1.data( 'connections', eq_1_list )
  eq_2.data( 'connections', eq_2_list )
  
  ret_path = $('#' + path_id)
  ret_path.data( 'eq_1', eq_1.attr('id') )
  ret_path.data( 'eq_2', eq_2.attr('id') ) 
  return ret_path
# ========================================================================= 

# ------------------------------------------------------------------------- 
# informed that the position of an expression has changed
changedExprPosition = ( expr ) ->
  file_zone = $("#fs_file_zone")
  fzpos = getPos( file_zone )
  expr_list = expr.data( 'connections' )
  for cnct_id, cnct_path_id of expr_list
    cnct_expr = $('#' + cnct_id)
    ln_to_expr = lineBetweenExpr( expr, cnct_expr, fzpos )
    if ln_to_expr
      if !cnct_path_id
        # we need to create the path
        cnct_path = createNewPath( file_zone, expr, cnct_expr )
      else
        # the path already exists
        cnct_path = $('#' + cnct_path_id)
      # console.log 'cnct_path_id', cnct_path_id 
      # console.log 'cnct_path', cnct_path 
      updatePath cnct_path, ln_to_expr, fzpos
     else
       # no line because they overlap
       cnct_path = $('#' + cnct_path_id)
       if cnct_path.length is not 0
         # the path exists but is not needed; delete it
         cnct_path.remove()
         expr_list[cnct_id] = null
  # paths may have been added or removed
  expr.data( 'connections', expr_list )
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# hovering over an expression
onHoverExpressionIn = ( event ) ->
  the_expr = $(this)
  changeCurrentObject the_expr
# ========================================================================= 

# ------------------------------------------------------------------------- 
# hovering over an expression
onHoverExpressionOut = ( event ) ->
  0
# ========================================================================= 

# ------------------------------------------------------------------------- 
# change the object that is merked as being current
changeCurrentObject = ( new_crt ) ->
  # set current style for this expression
  new_crt.addClass( 'infile_crt' )
  new_crt_id = new_crt.attr('id')
  # remove current style for previous current, if any
  jfile_zone = $("#fs_file_zone")
  crt_expr_id = jfile_zone.data( 'crt_expr_id' )
  if crt_expr_id
    if new_crt_id is crt_expr_id
      return
    crt_expr = $('#'+crt_expr_id)
    crt_expr.removeClass( 'infile_crt' )
  jfile_zone.data( 'crt_expr_id', new_crt_id )  
  
  inner_text = new_crt.text()
  inner_text.replace /\$\$/, ''
  $("#expression_text").val( inner_text )
  $("#expression_text").data( 'crt_expression', new_crt_id )
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# creates a new expression and sets the content provided as argument
# @return the newly created expression or null
createNewExpr = (expr_text) ->
  # TODO parse input;
  # TODO engine specific markings
  
  
  # get a proper ID
  jfile_zone = $("#fs_file_zone")
  crt_expr_id = jfile_zone.data( 'crt_expr_id' )
  jfile_zone.data( 'crt_expr_id', crt_expr_id+1 )
  crt_expr_id = 'expression_' + crt_expr_id
  
  # insert a new 
  jfile_zone.append('<div class="expression" id="' + 
                    crt_expr_id + '">$$' + expr_text + '$$</div>')
  new_expr = $('#' + crt_expr_id )
  new_expr.hover( onHoverExpressionIn, onHoverExpressionOut )
  
  # TODO post to save in the database
  
  setExpressionCustoms( new_expr )
  return new_expr
# ========================================================================= 

# ------------------------------------------------------------------------- 
# sets the selected elements as expressions
setExpressionCustoms = ( expr_sel ) ->
  expr_sel.draggable({ containment: $("#fs_file_zone") })
  expr_sel.on "drag", (event, ui) ->
    changeCurrentObject $(this)
    changedExprPosition $(this)
  expr_sel.click( ->
    changeCurrentObject $(this)
  )
# ========================================================================= 

# ------------------------------------------------------------------------- 
# presents an error message related to the files
dfileError = ( error_text ) ->
  alert error_text
  # TODO proper message
# ========================================================================= 

# ------------------------------------------------------------------------- 
# presents an informative message related to the files
dfileInfo = ( info_text ) ->
  console.log info_text
  # TODO proper message
# ========================================================================= 

# ------------------------------------------------------------------------- 
# clears the error message related to the files
dfileInfoClear = ->
  return 0
  # TODO proper message
# ========================================================================= 

# ------------------------------------------------------------------------- 
# on click handler for selecting parts to connect
onClickConnect = ( event ) ->
  jfile_zone = $("#fs_file_zone")
  crt_expr = $(this)
  crt_expr_id = crt_expr.attr('id')
  while true
    first_id = jfile_zone.data( 'connect_first' )
    if first_id
      # this is the second expression
      first_eq = $('#' + first_id)
      if first_eq.length is 0
        # may have been deleted meanwhile
        break
      if first_id is crt_expr_id
        # same expression selected; ignored
        console.log 'same expression selected; ignored'
        return
      first_eq_list = first_eq.data( 'connections' )
      if first_eq_list
        if first_eq_list[crt_expr_id]
          console.log 'There is already a connection between these two expressions'
          return
      new_path = createPathDOM( first_id, crt_expr_id )
      if new_path
        dfileInfoClear
      else
        dfileError 'Failed to create the path!'
      $(".expression").off 'click', onClickConnect
      jfile_zone.data( 'connect_first', null )
      console.log 'Connection was set'
      return
    else
      break

  # this is the first expression
  dfileInfo 'Select second expression to connect'
  jfile_zone.data( 'connect_first', crt_expr_id )

# ========================================================================= 

# ------------------------------------------------------------------------- 
# creates a new context inside specified one or inside the file context
# if null is provided
createNewContext = ( parent_ctx )->
  # get a proper ID
  jfile_zone = $("#fs_file_zone")
  crt_ctx_id = jfile_zone.data( 'crt_ctx_id' )
  jfile_zone.data( 'crt_ctx_id', crt_ctx_id+1 )
  crt_ctx_id = 'context_' + crt_ctx_id
  console.log 'crt_ctx_id',crt_ctx_id

  if !parent_ctx
    parent_ctx = jfile_zone

  jfile_zone.prepend('<div class="sheetcontext" id="' + 
                    crt_ctx_id + '"><div class="sheetcontext_rsz" id="' + 
                    crt_ctx_id + '_rsz"></div></div>')
  new_ctx = $('#' + crt_ctx_id)
  new_ctx_rsz = $('#' + crt_ctx_id + '_rsz')

  new_ctx_opts =
    autoHide: true # hide handlers when not hovering
    containment: parent_ctx # keep it inside the parent
    #handles: 's, w' # resize available in all directions
    minHeight: 30
    minWidth: 30
  new_ctx.draggable({ containment: parent_ctx })
  new_ctx_rsz.resizable( new_ctx_opts )
  console.log 'new_ctx',new_ctx
  
  # containment does not work (allows resizing outside file area)
  # when main window is resized the components are thrown outside
  return new_ctx
  
# ========================================================================= 

#  INTERNAL FUNCTIONS    ==================================================
#
#
#
#
#  EXTERNAL FUNCTIONS    --------------------------------------------------

# ------------------------------------------------------------------------- 
@sheetInit = ->
  
  # make display area resizable
  resz_opts =
    autoHide: false # hide handlers when not hovering
    handles: 's'
    minHeight: 30
    minWidth: 30
  jfile_zone = $("#fs_file_zone")
  jfile_zone.resizable( resz_opts )
  
  # redirect sheet toolbar to our handling function
  $("a[id^=tbsheet_]").click( ->
    sheetAction( this.id );
  )
  
  text_area = $('#expression_text')
  text_area.toolbar
    content: '#sheet_toolb'
    position: 'bottom'
    hideOnClick: true
  
  afterSheetLoad();
  createPath('expression_98','expression_99')
# ========================================================================= 

# ------------------------------------------------------------------------- 
# invoked once after a mathsheet has been loaded
@afterSheetLoad = ->
  jfile_zone = $("#fs_file_zone")
  all_expr = $(".expression")
  
  # prepare initial identificators
  setExpressionCustoms all_expr
  jfile_zone.data( 'crt_expr_id', 100 )
  jfile_zone.data( 'crt_path_id', 100 )
  jfile_zone.data( 'crt_ctx_id', 100 )
# ========================================================================= 

# ------------------------------------------------------------------------- 
# takes two expression ids and creates the association between them
# this does not create the actual DOM objectsreatePathDOM, only the symbolic link
# to actually create the path use createNewPath() or changedExprPosition()
@createPath = (eq_id_1,eq_id_2) ->

  # get the two expressions
  eq_1 = $('#'+eq_id_1)
  eq_2 = $('#'+eq_id_2)
  # get the lists
  eq_1_list = eq_1.data( 'connections' )
  eq_2_list = eq_2.data( 'connections' )
  if not eq_1_list  
    eq_1_list = {}
  if not eq_2_list
    eq_2_list = {}
  # save the path in both expressions
  eq_1_list[eq_id_2] = null # will be created in changedExprPosition
  eq_2_list[eq_id_1] = null
  eq_1.data( 'connections', eq_1_list )
  eq_2.data( 'connections', eq_2_list )
  return
# ========================================================================= 

# ------------------------------------------------------------------------- 
# takes two expression ids and creates the association between them
# this does create the actual DOM objects, unlike createPath
@createPathDOM = (eq_id_1,eq_id_2) ->
  createPath eq_id_1,eq_id_2
  changedExprPosition $( '#' + eq_id_1 )

# ========================================================================= 

# ------------------------------------------------------------------------- 
# responds to toolbar actions
# @return nothing
@sheetAction = (action_id) ->
  action_id = action_id.replace /tbsheet_/, ''
  switch action_id
  
  
    when 'create_new'
      expr_text = $("#expression_text").val()
      if expr_text is ''
        alert "No content to add as a new expression"
        return
      createNewExpr( expr_text )
      
      
    when 'update'
      crt_expr_id = $("#expression_text").data( 'crt_expression' )
      if not crt_expr_id
        alert "There is no current expression"
        return
      crt_expr = $("#" + crt_expr_id)      
      if crt_expr.length == 0
        alert "There is no current expression"
        return
      
      expr_text = $("#expression_text").val()
      if expr_text is ''
        alert "No content to add to the expression"
        return
      # TODO parse input;
      # TODO engine specific markings
      crt_expr.html( '$$' + expr_text + '$$' );
      
      
    when 'connect'
      # connect_first is used to store the ID of the first expression 
      # to connect in fs_file_zone element      
      jfile_zone = $("#fs_file_zone")
      if jfile_zone.data( 'connect_first' )
        jfile_zone.data( 'connect_first', null )
        dfileInfoClear
      else
        # attach event listner to all expressions
        $(".expression").on 'click', onClickConnect
        dfileInfo 'Select first expression to connect'
        
        
    when 'context'
      createNewContext()
        
        
    else
      dfileError 'Coding error!'
      return
# ========================================================================= 


#  EXTERNAL FUNCTIONS    ==================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
