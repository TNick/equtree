
@dfile_make_draggable = ->
  $(".equation").draggable({ containment: $("#fs_content_file") })
  console.log $(".equation")
  