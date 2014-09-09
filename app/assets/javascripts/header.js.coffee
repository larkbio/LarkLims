ready = ->
  console.log("header coffeescript ready fn called")
  $("#home_icon").click ->
    window.location = '/'

$(document).ready(ready)
$(document).on('page:load', ready)
