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
#  FUNCTIONS    ----------------------------------------------------------- 

# $ ->
  # $('#directory_tree').jstree.bind 'rename_node.jstree', (event, data) ->
    # console.log event
    # console.log data
# $ ->
  # $("#directory_tree").bind("open_node.jstree close_node.jstree", (e) ->
    # console.log event
    # console.log data
  # )

`
// UPDATED -> NOW WORKS WITH jQuery 1.3.1
$.fn.listHandlers = function(events, outputFunction) {
    return this.each(function(i){
        var elem = this,
            dEvents = $(this).data('events');
        if (!dEvents) {return;}
        $.each(dEvents, function(name, handler){
            if((new RegExp('^(' + (events === '*' ? '.+' : events.replace(',','|').replace(/^on/i,'')) + ')$' ,'i')).test(name)) {
               $.each(handler, function(i,handler){
                   outputFunction(elem, '\n' + i + ': [' + name + '] : ' + handler );
               });
           }
        });
    });
};
`
# ------------------------------------------------------------------------- 
# initialises the filesystem components for a page
@fsInit = ->
  
  # Define any icon actions before calling the toolbar 
  $('.toolbar-icons a').on 'click', (event) ->
    event.preventDefault()

  
  # hide the event nofifier
  $('#fs_notifiers').hide()
  
  # toolbar set-up before use
  dt = $('#directory_tree')
  dt.toolbar
    content: '#fs_toolb'
    position: 'bottom'
    hideOnClick: true

  dt.jstree
    themes:
      theme: 'classic'
      dots: 'true'
      icons: 'true'
    types:
      types:
        directory:
          icon:
            image: 'assets/themes/classic/d.png'
            position: '-56px -18px'
        generic:
          icon:
            image: 'assets/fatcow-icons-16.png'
            position: '0px 0px'
        mathsheet:
          icon:
            image: 'assets/fatcow-icons-16.png'
            position: '-16px 0px'
      ui:
        select_limit: 1
    plugins: ['themes', 'html_data', 'ui', 'crrm', 'hotkeys', 'types']

  #dt.bind 'select_node.jstree', (event, data) ->
  dt.jstree.bind 'rename_node.jstree', (event, data) ->
    console.log event
    console.log data
  
  $('*').listHandlers('*', console.log);
  
  # dt.bind("move_node.jstree", (event, data) ->
    # alert "move"
  # ).bind("rename_node.jstree", (event, data) ->
    # alert "rename"
  # ).bind "create_node.jstree", (event, data) ->
    # alert "create_node"

    
    # ajax_data =
      # action_id: 'edit_name'
      # name: "port"
      # sel_id: sel_kind[1]
      # sel_kind: sel_kind[0]
      # move_ty: move_type
      # other_id: other_id
      # type: 2 # Dfile::FTYPE_SHEET  
    # fsSendAjax dt, ajax_data

  
  #var elem = document.getElementById('dir_selectedid');
  #elem.value = data.rslt.obj.attr('id');
  # setTimeout (->
    # dt.jstree 'set_focus'
  # ), 100

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
    url: 'directories'
    dataType: "json"
    data: ajax_data
  ).done( (data) ->
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
        dt.jstree( 'select_node', new_tag )
        
        
      when 'edit_name'
        new_tag = null
        if data.kind_name is 'directory'
          new_tag = $( '#fs_edir_' + data.new_id )
        else
          new_tag = $( '#fs_efile_' + data.new_id )
        
        console.log new_tag
        if new_tag.length is 0
          fsError 'Item was not found on server; try to refresh the page.'
          return
        dt.jstree( 'rename_node', new_tag, data.new_name )
        
        
#       when 'cut'
#         
#       when 'copy'
#         
#       when 'paste'
#         
#       when 'delete'
#         
#       when 'undo'
#       
#       when 'redo'
#         # move along
#       else
#         
                                   
    #fsNotify 'Directory ' + new_name + ' was created'
    
  ).fail(->
    fsError 'Can`t create directory ' + new_name + '.<br>' + jqxhr.statusText
  )

#.always(function() { alert('finished'); });
# ========================================================================= 

# ------------------------------------------------------------------------- 
@fsAction = (action_id) ->
  fsHideNotif()
  $('*').listHandlers('*', console.log);
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
      type: 2 # Dfile::FTYPE_SHEET to create 
  fsSendAjax dt, ajax_data

# ========================================================================= 

#  FUNCTIONS    =========================================================== 
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
