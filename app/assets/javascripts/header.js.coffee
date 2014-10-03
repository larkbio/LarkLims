ready = ->
  console.log("header coffeescript ready fn called")
  $("#home_icon").click ->
    window.location = '/'

$(document).ready(ready)
$(document).on('page:load', ready)

@show_error = (msg) ->
  $("#error-message").removeClass("hidden")
  $("#error-message span.msg").html("Error message: "+msg)
  $("#orders-table").addClass("hidden")

@hide_error = (msg) ->
  $("#error-message span.msg").html("")
  $("#error-message").addClass("hidden")
  $("#orders-table").removeClass("hidden")