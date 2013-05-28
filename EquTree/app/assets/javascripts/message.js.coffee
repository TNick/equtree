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

#  DATA    ================================================================ 
#
#
#
#
#  INTERNAL FUNCTIONS    --------------------------------------------------

# ------------------------------------------------------------------------- 
# stop the timer
@stopTimer = ->
  console.log "stopTimer", window.timer_id_message, window.timer_id_message.length
  i = 0
  while i < window.timer_id_message.length
    console.log 'i=',i
    clearInterval( window.timer_id_message );
    i++
  window.timer_id_message = []
  console.log "^stopTimer", window.timer_id_message
# ========================================================================= 

# ------------------------------------------------------------------------- 
# start the timer
@startTimer = (interval) ->
  stopTimer()
  window.timer_seconds_message = 5
  window.timer_id_message[0] = setInterval( onMsgPanelSecond, interval )
  console.log 'window.timer_id_message', window.timer_id_message
  console.log 'window.timer_seconds_message', window.timer_seconds_message
  
# ========================================================================= 


# ------------------------------------------------------------------------- 
# path components click
@onMsgPanelClick = (event) ->
  stopTimer()  
  $('#msgp_button').text( 'Close' )
  event.stopPropagation()
  return 0
# ========================================================================= 

# ------------------------------------------------------------------------- 
# hide button click
@onMsgPanelButtonClick = (event) ->
  window.timer_seconds_message = 0
  $('#message_panel').hide()
  event.stopPropagation()
# ========================================================================= 

# ------------------------------------------------------------------------- 
# path components click
@onMsgPanelSecond = () ->

  console.log 'onMsgPanelSecond', window.timer_seconds_message, window.timer_id_message
  window.timer_seconds_message--;
  $('#msgp_button').text( 'Close (' + window.timer_seconds_message + ')' )
  if window.timer_seconds_message <= 0
    stopTimer()
    $('#message_panel').hide()
    console.log "Timer expired; message was hidden"

# ========================================================================= 

# ------------------------------------------------------------------------- 
# generic message presenter
@presentMessage = (message,msg_type,clear_previous) ->
  if clear_previous is undefined
    clear_previous = true
  
  console.log message, msg_type, clear_previous
  if clear_previous
    console.log 'Clearing'
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
  
  
  # the id of the timer we're using to hide the message
  window.timer_id_message = []
  # seconds left until we're closing the dialog
  window.timer_seconds_message = 0
  
   
  # set-up event handlers
  the_msg = $('#message_panel')
  the_msg.on 'click', onMsgPanelClick
  the_msg_btn = $('#msgp_button')
  the_msg_btn.on 'click', onMsgPanelButtonClick

  # hide the message if the user is doing something else
  $('html').on 'click', ( ->
    $('#message_panel').hide()
    window.timer_seconds_message = 0
  )

  # only for testing
  # msgError('test')
  
# ========================================================================= 

# ------------------------------------------------------------------------- 
# presents the panel and starts the counter
@msgShow = ->
  console.log '@msgShow'
  window.timer_seconds_message = jQuery.jCookie('message-timeout')
  if ( not window.timer_seconds_message ) or ( window.timer_seconds_message < 2 )
    window.timer_seconds_message = 5
    jQuery.jCookie('message-timeout', window.timer_seconds_message)

  console.log 'window.timer_seconds_message', window.timer_seconds_message
  the_msg = $('#message_panel')
  the_msg.show()
  the_msg_btn = $('#msgp_button')
  the_msg_btn.text( 'Close (' + window.timer_seconds_message + ')' )
  #the_msg.css('top', ($(window).scrollTop()+50) + 'px')
  startTimer( 1000 )
  
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
  console.log message
  presentMessage(message,'info',clear_previous)
# ========================================================================= 

#  EXTERNAL FUNCTIONS    ==================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
