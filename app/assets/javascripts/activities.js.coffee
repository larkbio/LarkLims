# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@load_activities = ()  ->
  $.ajax '/activities/index',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"

      i = 0
      $("div#activity-list").empty()
      for act in data
        newactivity = $("#activity_template").children().first().clone()
        newid =  "act-" + i
        newactivity.attr('id', newid)
        if i == 0
          $("div#activity-list").html(newactivity)
        else
          newactivity.insertAfter($("div#activity-list").children().last())

        $("#"+newid+" i").addClass(act['activity_icon'])
        $("#"+newid+" div div.activity-time span").html(act['timediff']+' ago')
        $("#"+newid+" div div.activity-title").html(act['activity_title'])
        $("#"+newid+" div div.activity-details span").html(act['activity_detail'])
        i += 1

