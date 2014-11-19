# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@activity_limit = 20

@load_activities = ()  ->
  $.ajax '/activities/index?limit='+@activity_limit,
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
        $("#"+newid+" div div.activity-time span").html(act['odate'])
        $("#"+newid+" div div.activity-title").html(act['activity_title'])
        $("#"+newid+" div div.activity-details span").html(act['activity_detail'])
        i += 1
        before_date = act['date']
        before_order_id = act['order_id']
#        console.log "setting before_date: "+before_date
      $("input#before_date")[0].value = before_date
      $("input#before_order_id")[0].value = before_order_id

@load_and_append_activities = () ->
  before_date = $("input#before_date")[0].value
  before_order_id = $("input#before_order_id")[0].value
  $.ajax '/activities/index?limit='+@activity_limit+"&before_date="+before_date+"&before_order_id="+before_order_id,
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"
      console.log(data)
      i = 0

      for act in data
        newactivity = $("#activity_template").children().first().clone()
        newid =  "act-" + i
        newactivity.attr('id', newid)

        newactivity.insertBefore($("#activity-list div#progress-sign"))

        $("#"+newid+" i").addClass(act['activity_icon'])
        $("#"+newid+" div div.activity-time span").html(act['odate'])
        $("#"+newid+" div div.activity-title").html(act['activity_title'])
        $("#"+newid+" div div.activity-details span").html(act['activity_detail'])
        i += 1
        before_date = act['date']
        before_order_id = act['order_id']

      console.log "before_date = "+before_date+" before_id = "+before_order_id
      $("input#before_date")[0].value = before_date
      $("input#before_order_id")[0].value = before_order_id
      $("#activity-list div#progress-sign").remove()

@should_scroll = (elem) ->
  doc_top = $(window).scrollTop()
  doc_bottom = doc_top + $(window).height()
  elem_top = $(elem).offset().top
  elem_bottom = elem_top + $(elem).height()
  return (elem_bottom <= doc_bottom) && (elem_top >= doc_top)

scroll_handler = (event) ->
  scroll_top = $(window).scrollTop()
  scroll_down = false
  if scroll_top > @last_top
    scroll_down = true
  @last_top = scroll_top

  if scroll_down && should_scroll("#activity-list div.activity:last")
    console.log "need scroll"
    console.log event
    $("#activity-list div.progress-sign").remove()
    $("<div id=\"progress-sign\" class=\"activity progress-sign\"><div class=\"body\"><i class=\"fa fa-spinner fa-spin fa-stack-2x\"></i></div></div>").insertAfter($("#activity-list div.activity:last"))
    load_and_append_activities()


@dashboard_loaded = () ->
  console.log "dashboard loading"
  load_activities()
  @last_top = 0
  @timeout_id = null
  $(document).scroll (event) ->
    if @timeout_id
      clearTimeout(@timeout_id)
    @timeout_id = setTimeout( scroll_handler, 100)

