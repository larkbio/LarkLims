# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@load_users = ()  ->
  $.ajax '/users',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"

      i = 0
      $("#users-table").empty()
      for user in data
        new_user = $("#list_item_template").clone()
        new_id =  "usr-" + i
        new_user.attr('id', new_id)
        if i == 0
          $("ul#users-table").html(new_user)
        else
          new_user.insertAfter($("ul#users-table").children().last())
        i = i+1

        $("#"+new_id+" div a.browser-list-cell-title-link").html(user.name)
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/users/"+user.id)
        $("#"+new_id+" div div.browser-meta span").html(user.email)
