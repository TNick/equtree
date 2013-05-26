# ========================================================================= 
# ------------------------------------------------------------------------- 
#!
#  \date          May 2013
#  \author        TNick
#
#  \brief         Functions that deal with messages
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

# the id of the timer we're using to hide the message
timerId = 0

# seconds left until we're closing the dialog
timer_seconds = 0

#  DATA    ================================================================ 
#
#
#
#
#  INTERNAL FUNCTIONS    --------------------------------------------------

# ------------------------------------------------------------------------- 
# path components click
onMsgPanelClick = (event) ->
  clearInterval( timerId );
  $('#msgp_button').text( 'Close' )
  event.stopPropagation()
  return 0
# ========================================================================= 

# ------------------------------------------------------------------------- 
# hide button click
onMsgPanelButtonClick = (event) ->
  $('#message_panel').hide()
  event.stopPropagation()
# ========================================================================= 

# ------------------------------------------------------------------------- 
# path components click
onMsgPanelSecond = () ->
  timer_seconds--;
  $('#msgp_button').text( 'Close (' + timer_seconds + ')' )
  if ( timer_seconds <= 0 )
    clearInterval( timerId )
    $('#message_panel').hide()

# ========================================================================= 

# ------------------------------------------------------------------------- 
# generic message presenter
presentMessage = (message,msg_type,clear_previous) ->
  console.log clear_previous
  if clear_previous is undefined
    clear_previous = true
  
  if clear_previous
    msgClear()
  
  icon_class = 'eqticon16_' + msg_type
  the_msg_cnt = $('#msgp_content')
  the_msg_cnt.append( '<li class="msgp_entry_' + 
                     msg_type + '"><div class="' + icon_class + 
                     '"></div>&nbsp;' + message +  '</li>')
  msgShow()
  
# ========================================================================= 

#  INTERNAL FUNCTIONS    ==================================================
#
#
#
#
#  EXTERNAL FUNCTIONS    --------------------------------------------------

# ------------------------------------------------------------------------- 
# initialises the messages components for a page
@msgInit = ->
  console.log '@msgInit'
  
  # set-up event handlers
  the_msg = $('#message_panel')
  the_msg.on 'click', onMsgPanelClick
  the_msg_btn = $('#msgp_button')
  the_msg_btn.on 'click', onMsgPanelButtonClick

  # hide the message if the user is doing something else
  $('html').on 'click', ( ->
    if the_msg.is(":visible")
      the_msg.hide()
  )

  # only for testing
  msgError('test')
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# presents the panel and starts the counter
@msgShow = ->
  
  timer_seconds = jQuery.jCookie('message-timeout')
  if ( not timer_seconds ) or ( timer_seconds < 2 )
    timer_seconds = 5
    jQuery.jCookie('message-timeout', timer_seconds)

  the_msg = $('#message_panel')
  the_msg.show()
  the_msg_btn = $('#msgp_button')
  the_msg_btn.text( 'Close (' + timer_seconds + ')' )
  timerId = setInterval( onMsgPanelSecond, 1000)
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# remove all messages
@msgClear = ->
  the_msg_cnt = $('#msgp_content')
  the_msg_cnt.empty()
# ========================================================================= 

# ------------------------------------------------------------------------- 
# show an error message; may be either appended or may replace the content
# clear_previous defaults to true
@msgError = (message,clear_previous) ->
  presentMessage(message,'error',clear_previous)  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# show an informative message; may be either appended or may replace the content
# clear_previous defaults to true
@msgInfo = (message,clear_previous) ->
  presentMessage(message,'info',clear_previous)
# ========================================================================= 

#  EXTERNAL FUNCTIONS    ==================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
