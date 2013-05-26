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

# types of nodes
FSTYPE =
  INVALID : -1
  DIR : 0
  FILE : 1

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
fsFileNotif = (text) ->
  div_cnt = $('#fs_content_notifier')[0]
  #div_cnt.innerHTML = text
  div_cnt.style.color = 'blue'
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsFileErr = (text) ->
  div_cnt = $('#fs_content_notifier')[0]
  #div_cnt.innerHTML = text
  #div_cnt.style.color = 'red'
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsClearFileErr = (text) ->
  div_cnt = $('#fs_content_notifier')[0]
  #div_cnt.innerHTML = ''
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsRenderDirectory = (sel_id) ->
  # console.log 'fsRenderDirectory'
  dt = $('#directory_tree')
  cont_dir = $("#fs_content_dir")
  
  if sel_id
    # render a sub-directory
    sel_node = $('#' + sel_id)
    # console.log 'sel_id', sel_id
    #parent_node = dt.jstree( '_get_parent', sel_node )
    # WARNING _get_parent is unreliable!!!
    parent_node = dt.jstree( 'get_path', sel_node, true )
    # console.log 'parent_node', parent_node
    if parent_node.length <= 1
      parent_node = ''
    else
      parent_node = parent_node[parent_node.length-2]
    # console.log 'parent_node', parent_node
    allChildren = sel_node.children('ul').children('li')
    cont_dir.append( '<div id="fs_cdir_name" class="fs_cdir_name">' + 
                    dt.jstree( 'get_text', sel_node ) + '</div>\n' +
                    '<a href="#" id="fs_cdir_parent" data-node="' + parent_node +
                    '" >.. parent directory</a>')
    $('#fs_cdir_parent').on 'click', (event) ->
      event.preventDefault()
      fsDirNavigate(this)
  else
    # render top level directory (the user)
    allChildren = dt.children('ul').children('li')
    cont_dir.append('<div id="fs_cdir_name" class="fs_cdir_name">Root directory</div>')
  
  # iterate in all nodet at this level
  i = 0
  while i < allChildren.length
    the_node = $(allChildren[i])
    icn = the_node.attr('rel')
    if icn is 'directory'
      icn = 'eqticon16_directory'
    else if icn is 'mathsheet'
      icn = 'eqticon16_mathsheet'
    else
      icn = 'eqticon16_generic'
    cont_dir.append('<a href="#" class="fs_cdir_entry" data-node="' + 
                    the_node.attr('id') + '">' + 
                    '<div class="' + icn + '"></div>&nbsp;' + 
                    dt.jstree( 'get_text', allChildren[i] ) + "</a>")
    i++
  cont_dir.show()
  
  $('.fs_cdir_entry').on 'click', (event) ->
    event.preventDefault()
    fsDirNavigate(this)
  0
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsGetFileContent = (file_id) ->
  fsClearFileErr()
  
  ajax_data = 
    source_file: file_id
    
  jqxhr = $.ajax(
    type: 'POST'
    url: '/files'
    dataType: "json"
    data: ajax_data
  ).done( (data) ->
    
    if data.source_file is not file_id 
      fsFileErr 'Bogus response from the server'
    else
      switch data.file_type
        when 'mathsheet'
          fsRender_MathSheet(file_id,data)
        else
          fsFileErr("Unknown file type: " + data.file_type )
      # TODO check if the type of the file changed on the server
      # and change icon appropriatelly
  ).fail(->
    fsFileErr 'Server querry failed.<br>' + 
      jqxhr.responseText + '.<br>' + 
      'status: ' + jqxhr.statusText
  )
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsRender_MathSheet = (file_id,data) ->
  
  if data.file_type != 'mathsheet'
    fsFileErr("Wrong file type: : " + data.file_type )
    return
  
  top_div = jQuery('#fs_file_zone')
  
  console.log 'fsRender_MathSheet', data


# ========================================================================= 

# ------------------------------------------------------------------------- 
fsShowNotif = ->
  div_ntf = $('#fs_notifiers')
  div_ntf.show()
  setTimeout (->
    div_ntf.fadeOut 'fast'
  ), 10000 # <-- time in milliseconds
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsHideNotif = ->
  div_ntf = $('#fs_notifiers')
  div_ntf.fadeOut 'fast'
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsNotify = (text) ->
  div_cnt = $('#fs_notifier_cont')[0]
  div_cnt.innerHTML = text
  div_cnt.style.color = 'blue'
  fsShowNotif()
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsError = (text) ->
  div_cnt = $('#fs_notifier_cont')[0]
  div_cnt.innerHTML = 'Error! ' + text
  div_cnt.style.color = 'red'
  fsShowNotif()
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsClipboardCut = (it_id) ->
  dt = $('#directory_tree')[0]
  dt.data('clipboard-it',it_id)
  dt.data('clipboard-ty','cut')
  # TODO visual signal that something is in clipboard
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsClipboardCopy = (it_id) ->
  dt = $('#directory_tree')[0]
  dt.data('clipboard-it',it_id)
  dt.data('clipboard-ty','copy')
  # TODO visual signal that something is in clipboard
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsIdKind = (it_id) ->
  if /fs_edir_[0-9]+/.test(it_id)
    return [FSTYPE.DIR,it_id.replace(/fs_edir_/,'') ]
  else if /fs_efile_[0-9]+/.test(it_id)
    return [FSTYPE.FILE,it_id.replace('fs_efile_','')]
  return [FSTYPE.INVALID,-1]
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsClipboardPaste = (dest_id,to_paste,move_type) ->
  dt = $('#directory_tree')[0]
  if to_paste is null or to_paste is ''
    fsError 'There is nothing to paste.'
    return false
  if fsIdKind(dest_id)[0] is not STYPE.DIR
    fsError 'Only directories may contain other items.'
    return false
  
  if move_type is 'cut'
    dt.data('clipboard-it','')
    dt.data('clipboard-ty','')
    # TODO visual signal that something is no longer in clipboard
  
  return true
# ========================================================================= 

# ------------------------------------------------------------------------- 
fsSendAjax = (dt,ajax_data) ->

  jqxhr = $.ajax(
    type: 'POST'
    url: '/directories'
    dataType: "json"
    data: ajax_data
  ).done( (data) ->
    console.log 'fsSendAjax data back', data
    parent_tag = $('#fs_edir_'+data.parent_id)
    switch data.action_id
    
    
      when 'new_file'
        node_data =
          'data' : data.new_name
          'attr' : 
            'id' : 'fs_efile_' + data.new_id
            'rel': data.kind_name
        if parent_tag.length is 0 # root directory
          new_tag = dt.jstree( 'create',-1,"last",node_data,false,true )
        else          # subdirectory
          new_tag = dt.jstree( 'create',parent_tag,"inside",node_data,false,true )
        dt.jstree( 'deselect_all' )
        new_tag.addClass( 'file-entry' )
        dt.jstree( 'select_node', new_tag )
        
      when 'new_dir'
        node_data =
          'data' : data.new_name
          'attr' : 
            'id' : 'fs_edir_' + data.new_id
            'rel': data.kind_name
        if parent_tag.length is 0 # root directory
          new_tag = dt.jstree( 'create',-1,"last",node_data,false,true )
        else          # subdirectory
          new_tag = dt.jstree( 'create',parent_tag,"inside",node_data,false,true )
        dt.jstree( 'deselect_all' )
        new_tag.addClass( 'directory-entry' )
        dt.jstree( 'select_node', new_tag )
        
        
      when 'edit_name'
        new_tag = null
        if data.kind_name is 'directory'
          new_tag = $( '#fs_edir_' + data.new_id )
        else
          new_tag = $( '#fs_efile_' + data.new_id )
        
        if new_tag.length is 0
          fsError 'Item was not found on server; try to refresh the page.'
          return
        dt.changing_name = true
        dt.jstree( 'rename_node', new_tag, data.new_name )
        dt.changing_name = false
        
        
      when 'delete'
        new_tag = null
        if data.kind_name is 'directory'
          new_tag = $( '#fs_edir_' + data.new_id )
        else
          new_tag = $( '#fs_efile_' + data.new_id )
        if new_tag.length is 0
          # TODO no error until we're not able to prevent item deletion
          # fsError 'Item was not found on server; try to refresh the page.'
          return
        dt.deleting_node = true
        dt.jstree( 'delete_node', new_tag, data.new_name )
        dt.deleting_node = false
  ).fail(->
    fsError 'Server querry failed.<br>' + 
      jqxhr.responseText + '.<br>' + 
      'status: ' + jqxhr.statusText
      
    
  )

          
        #       when 'cut'
        #         
        #       when 'copy'
        #         
        #       when 'paste'
        #            
        #       when 'undo'
        #       
        #       when 'redo'
        #         # move along
        #       else
        #         
    
#.always(function() { alert('finished'); });
# ========================================================================= 

# ------------------------------------------------------------------------- 
# path components click
onPathComponentsClick = (event) ->
  # console.log 'click', this
  event.preventDefault()
  fsDirNavigate(this)
  return 0
# ========================================================================= 

# ------------------------------------------------------------------------- 
# selection has changed in the tree
internalTreeSelChange = ( new_sel ) ->
  # console.log 'internalTreeSelChange',new_sel
  display_type = null
  dt = $('#directory_tree')
  sel_id = false
  if new_sel
    sel_id = new_sel.attr("id");
    sel_kind = fsIdKind sel_id # [0] - FSTYPE, [1] - index of that item
  # console.log 'sel_id', sel_id
  path_html = '<a href="#" class="pathcomponents">Root</a>'
  $('#fs_content_dir').hide()
  $('#fs_file_zone').hide()
  $('#fs_content_dir').empty()
  $('#fs_file_zone').empty()
  if ( not sel_id ) or ( sel_kind[0] is FSTYPE.INVALID )
    # console.log 'root dir'
    fsRenderDirectory()
  else
    if ( sel_kind[0] == FSTYPE.DIR )
      $('#fs_content_dir').show()
      fsRenderDirectory sel_id
      display_type = 'dir'
    else
      $('#fs_file_zone').show()
      #file_type = jQuery('#' + sel_id).attr('rel')
      fsGetFileContent sel_kind[1]
      display_type = 'file'
    
    # get the path for this component
    path_comp = dt.jstree( 'get_path', new_sel, true )
    i = 0
    i_max = path_comp.length
    while i < i_max
      itr_id = path_comp[i]
      path_html = path_html + 
        '/<a href="#" class="pathcomponents" data-node="' + 
        itr_id + '">' + dt.jstree( 'get_text', $('#'+itr_id) ) + '</a>'
        i = i + 1

  # console.log 'not root dir'
  # $('#fs_content_header').text( '/' + dt.jstree( 'get_path', new_sel ).join('/') )
  $('#fs_content_header').html( path_html )
  $('.pathcomponents').on 'click', onPathComponentsClick
  
  jQuery.jCookie('user-display-type', display_type)
  jQuery.jCookie('user-display-id', sel_id)
  
  # console.log 'user-display-type', display_type, jQuery.jCookie('user-display-type')
  # console.log 'user-display-id', sel_id, jQuery.jCookie('user-display-id')
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# click handler for the tree of files
onTreeSelChange = (event, data) -> 
  # console.log 'onTreeSelChange'
  internalTreeSelChange data.rslt.obj

# ========================================================================= 

#  INTERNAL FUNCTIONS    ==================================================
#
#
#
#
#  EXTERNAL FUNCTIONS    --------------------------------------------------


# ------------------------------------------------------------------------- 
# initialises the filesystem components for a page
@fsInit = ->
  $('#fs_content_dir').hide()
  $('#fs_file_zone').hide()
  
  # Define any icon actions before calling the toolbar 
  $('.toolbar-icons a').on 'click', (event) ->
    event.preventDefault()
  $("a[id^=tb_]").click( ->
    fsAction( this.id );
  )
  
  # hide the event nofifier
  $('#fs_notifiers').hide()
  
  # toolbar set-up before use
  dt = $('#directory_tree')
  dt.toolbar
    content: '#fs_toolb'
    position: 'bottom'
    hideOnClick: true

  dt.jstree
    plugins: ['themes', 'html_data', 'ui', 'hotkeys', 'eqcrrm', 'types']
    themes:
      theme: 'classic'
      dots: 'true'
      icons: 'true'
    types:
      types:
        directory:
          icon:
            image: '/assets/themes/classic/d.png'
            position: '-56px -18px'
        generic:
          icon:
            image: '/assets/fatcow-icons-16.png'
            position: '0px 0px'
        mathsheet:
          icon:
            image: '/assets/fatcow-icons-16.png'
            position: '-16px 0px'
      ui:
        select_limit: 1

  #setTimeout (->
  #  dt.jstree 'set_focus'
  #), 100
  

  $('#directory_tree').bind 'select_node.jstree', onTreeSelChange
  
  # prevent anchors inside nodes to fire
  $('#initial-tree-entry').on 'click', (event) ->
      event.preventDefault()
  
  
  view_selected = false
  while true
    if ( jQuery.jCookie('user-display-name') is not document.title )
      break
    display_type = jQuery.jCookie('user-display-type')
    display_id = jQuery.jCookie('user-display-id' )
    # console.log 'display_id', display_id
    the_node = $('#'+display_id)
    if the_node.length is 0
      break
    if ( display_type is 'dir' ) or ( display_type is 'file' )
      view_selected = true
      dt.jstree( 'select_node', the_node )
    break
  if not view_selected
    internalTreeSelChange()
  jQuery.jCookie('user-display-name', document.title )
  

# ========================================================================= 

# ------------------------------------------------------------------------- 
@fsAction = (action_id) ->
  fsHideNotif()
  dt = $('#directory_tree')
  action_id = action_id.replace /tb_/, ''
  sel_id = dt.jstree('get_selected').attr('id')
  sel_kind = fsIdKind sel_id
  new_name = ''
  other_id = dt.data('clipboard-it')
  move_type = dt.data('clipboard-ty')
  
  switch action_id
    when 'new_file'
      new_name = prompt('Please enter file name', 'New file')
      if new_name is null or new_name is ''
        return
      
    when 'new_dir'
      new_name = prompt('Please enter directory name', 'New directory')
      if new_name is null or new_name is ''
        return
      
    when 'edit_name'
      if sel_kind[0] is FSTYPE.INVALID
        fsError 'No item to rename.'
        return
      else
        # $("#demo1").jstree("rename",node)
        new_name = prompt('Please enter new name', '')
        if new_name is null or new_name is ''
          return
      
    when 'cut'
      if sel_kind[0] is FSTYPE.INVALID
        fsError 'No item selected.'
        return
      fsClipboardCut sel_id
      return
    when 'copy'
      if sel_kind[0] is FSTYPE.INVALID
        fsError 'No item selected.'
        return
      fsClipboardCopy sel_id
      return
    when 'paste'
      if not fsClipboardPaste(sel_id,other_id,move_type)
        return
    when 'delete'
      if sel_kind[0] is FSTYPE.INVALID
        fsError 'No item to delete.'
        return
      else
        if not confirm( 'Are you sure you want to delete the item?' )
          return
    when 'undo', 'redo'
      # move along
    else
      fsError 'Coding error!'
      return
  
  ajax_data =
      action_id: action_id
      name: new_name
      sel_id: sel_kind[1]
      sel_kind: sel_kind[0]
      move_ty: move_type
      other_id: other_id
      ftype: 2 # Dfile::FTYPE_SHEET to create TODO get from node
  fsSendAjax dt, ajax_data

# TODO there is a second POST response with entire page. Why?

# ========================================================================= 

# ------------------------------------------------------------------------- 
@fsDirNavigate = ( the_anchor_raw ) ->
  dt = $('#directory_tree')
  the_anchor = $(the_anchor_raw)
  node_id = the_anchor.data( 'node' )
  dt.jstree( 'deselect_all' )
  # console.log 'node_id', node_id
  if node_id
    if node_id is 'directory_tree'
      # console.log "node_id is directory_tree"
      internalTreeSelChange()
    else
      # console.log "node_id is not directory_tree"
      dt.jstree( 'select_node', $('#'+node_id ) )
  else
    # console.log "no node_id"
    internalTreeSelChange()
    
# ========================================================================= 

#  EXTERNAL FUNCTIONS    ==================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 


  # jQuery('#directory_tree').bind 'rename_node.jstree', (event, data) -> 
    # if dt.changing_name is true
      # return
    # dt.changing_name = true
    # sel_id = data.rslt.obj.attr('id')
    # sel_kind = fsIdKind sel_id
    # ajax_data =
      # action_id: 'edit_name'
      # name: data.rslt.name
      # sel_id: sel_kind[1]
      # sel_kind: sel_kind[0]
      # move_ty: ''
      # other_id: -1
      # ftype: 2 # Dfile::FTYPE_SHEET to create TODO from node
    # fsSendAjax dt, ajax_data
    # dt.changing_name = false
    #TODO find a way to set the name back to its original value
    #dt.jstree( 'rename_node', data.rslt.obj, data.rslt.obj.text().replace(data.rslt.name,'').trim()  )

  # jQuery('#directory_tree').bind 'delete_node.jstree', (event, data) -> 
    # if dt.deleting_node is true
      # return
    # dt.deleting_node = true
    # sel_id = data.rslt.obj.attr('id')
    # sel_kind = fsIdKind sel_id
    # ajax_data =
      # action_id: 'delete'
      # name: data.rslt.name
      # sel_id: sel_kind[1]
      # sel_kind: sel_kind[0]
      # move_ty: ''
      # other_id: -1
      # ftype: 2 # Dfile::FTYPE_SHEET to create 
    # fsSendAjax dt, ajax_data
    # dt.deleting_node = false
    # TODO find a way to prevent the delete TODO from node

