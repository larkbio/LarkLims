# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@bind_order_events = () ->

  $("#new-order-button").click (event) ->
    new_order_handler(event)
    $("#paging-row").addClass("hidden")
    $("#new-order-button").addClass("hidden")

  $("#browser-select-all").click () -> all_orders_toggled()

  $("#delete-order").click () -> delete_selected_orders()

  $("#orders-table").delegate("li label input", "click", order_selected )

  $("ul#orders-table").delegate("li div.browser-list-cell a.browser-list-cell-title-link", "click", show_order_handler )

  close_modals = () ->
    $("#filter-status-modal").addClass("hidden")
    $("#filter-sort-modal").addClass("hidden")
    $(document).off("click")

  $("#filter-status-button").click (event) ->
    console.log "status"
    event.stopPropagation()
    $("#filter-status-modal").removeClass("hidden")
    $(document).click () -> close_modals()

  $("#filter-sort-button").click () ->
    event.stopPropagation()
    $("#filter-sort-modal").removeClass("hidden")
    $(document).click () -> close_modals()

  $("#filter-status-button-open").click () ->
    event.preventDefault()
    $("#filter-status-button-closed").removeClass("selected")
    $("#filter-status-button-open").addClass("selected")
    $("#order-user-filter")[0].value = ""
    $("#order-status-filter")[0].value = "open"
    load_orders()

  $("#filter-status-button-closed").click () ->
    event.preventDefault()
    $("#filter-status-button-closed").addClass("selected")
    $("#filter-status-button-open").removeClass("selected")
    $("#order-user-filter")[0].value = ""
    $("#order-status-filter")[0].value = "closed"
    load_orders()

  $("#filter-sort-newest").click () ->
    event.preventDefault()
    $("#filter-sort-newest").addClass("selected")
    $("#filter-sort-oldest").removeClass("selected")
    $("#order-sort-direction")[0].value = ""
    load_orders()

  $("#filter-sort-oldest").click () ->
    event.preventDefault()
    $("#filter-sort-newest").removeClass("selected")
    $("#filter-sort-oldest").addClass("selected")
    $("#order-sort-direction")[0].value = "oldest"
    load_orders()

  $("#order-stat-open").click (event) ->
    event.preventDefault()
    $("#order-user-filter")[0].value = ""
    $("#order-status-filter")[0].value = "open"
    load_orders()

  $("#order-stat-closed").click (event) ->
    event.preventDefault()
    $("#order-user-filter")[0].value = ""
    $("#order-status-filter")[0].value = "closed"
    load_orders()

@orders_button_handle_click = () ->
  unselect_menus()

  # inactivate filters
  $("#order-user-filter")[0].value = ""
  $("#order-status-filter")[0].value = ""
  $("#order-sort-direction")[0].value = ""
  $("#filter-status-button-closed").removeClass("selected")
  $("#filter-status-button-open").removeClass("selected")
  $("#filter-sort-newest").addClass("selected")
  $("#filter-sort-oldest").removeClass("selected")

  $("#orders-button").addClass('selected')

  $("#browser-products-header").addClass("hidden")
  $("#new-order-table").addClass("hidden")

  $("#browser-list-header-tab").removeClass("hidden")
  $("#orders-title").removeClass('hidden')
  $("#orders-table").removeClass('hidden')
  $("#new-order-button").removeClass('hidden')
  $("#browser-select-all").removeClass("hidden")
  $("#browser-filter-controls").removeClass("hidden")
  load_orders(1)
  $("#paging-row").removeClass("hidden")
  $("#close-order-table").addClass("hidden")

@load_orders = (page)  ->
  if not page
    page = 1
  if $("#order-user-filter")[0].value
    created_by = "&created_by="+$("#order-user-filter")[0].value
  else
    created_by = ""

  if $("#order-status-filter")[0].value
    order_status="&status="+$("#order-status-filter")[0].value
  else
    order_status=""

  order_sortby = ""
  if $("#order-sort-direction")[0].value=="oldest"
    order_sortby="&sort_by=oldest"

  $.ajax '/orders?page='+page+created_by+order_status+order_sortby,
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (result, textStatus, jqXHR) ->
      console.log "Successful AJAX call"
      data = result['data']
      paging = result['paging']

      $("#order-stat-open").html("<i class=\"fa fa-arrow-circle-o-up\"></i> "+data[0].num_opened+" Open")
      $("#order-stat-closed").html("<i class=\"fa fa-check\"></i> "+data[0].num_closed+" Completed")

      i = 0
      $("#orders-table").empty()
      $("#paging-row").remove()

      for order in data
        new_order = $("#list_item_template").clone()
        new_id =  "ord-" + i
        new_order.attr('id', new_id)
        if i == 0
          $("ul#orders-table").html(new_order)
        else
          new_order.insertAfter($("ul#orders-table").children().last())
        i = i+1

        if ($("#current-user-adm")[0].value == "true") || ($("#current-user-id")[0].value == String(order.owner_id))
          $("#"+new_id+" label").html("<input type=\"checkbox\" id=\"del-"+order.id+"\">")

        if order.status ==0
          status_icon = "<i class=\"fa fa-clock-o\" style=\"color: #4183c4;\"></i> "
        else
          status_icon = "<i class=\"fa fa-check\" style=\"color: green;\"></i> "


        $("#"+new_id+" div a.browser-list-cell-title-link").html(status_icon+order.comment+" <span class=\"product-label qb"+(order.product_id % 12)+"\">"+order.product_name+"</span>")
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/orders/"+order.id)

        meta_det = "Ordered on "+order.order_date_fmt+" by <a id='"+new_id+"-owner-"+order.owner_id+"' class=\"user-filter-link\" href='#'>"+order.owner+"</a>"
        $("#"+new_id+" div div.browser-meta span").html(meta_det  )

      $("ul#orders-table").delegate("a.user-filter-link", "click", userfilter_clicked_handler)

      pagenum = paging['pagenum']
      $("<div id=\"paging-row\">
          <a id=\"order-first-page\" href=\"#\">First</a>
          <a id=\"order-prev-page\" href=\"#\">Prev</a>
          <span> "+page+" / "+pagenum+" </span>
          <a id=\"order-next-page\" href=\"#\">Next</a>
          <a id=\"order-last-page\" href=\"#\">Last</a>
      </div>").insertAfter($("ul#orders-table"))

      prevpage = paging['currpage']-1
      prevpage = Math.max(1, prevpage)
      nextpage = paging['currpage']+1
      nextpage = Math.min(pagenum, nextpage)
      $("#order-prev-page").click (event) ->
        event.preventDefault()
        load_orders(prevpage)
      $("#order-next-page").click (event) ->
        event.preventDefault()
        load_orders(nextpage)
      $("#order-first-page").click (event) ->
        event.preventDefault()
        load_orders(1)
      $("#order-last-page").click (event) ->
        event.preventDefault()
        load_orders(pagenum)

@userfilter_clicked_handler = () ->
  console.log "userfilter_clicked_handler()"
  event.preventDefault()
  a_clicked = event.target
  owner_id = a_clicked.id.split("-")[3]
  console.log "filtering for user: "+owner_id
  $("#order-user-filter")[0].value = owner_id
  load_orders(1)

@all_orders_toggled = (event) ->
  if $("#browser-select-all").prop('checked')
    $("#orders-table li label input").prop("checked", true)
    $("#browser-filter-controls").addClass("hidden")
    $("#browser-select-controls").removeClass("hidden")
  else
    $("#orders-table li label input").prop("checked", false)
    $("#browser-filter-controls").removeClass("hidden")
    $("#browser-select-controls").addClass("hidden")

@order_selected = (event) ->
  item_clicked = event.target
  if item_clicked.checked
    $("#browser-filter-controls").addClass("hidden")
    $("#browser-select-controls").removeClass("hidden")
  else
    all_unchecked = true
    for item in $("#orders-table li label input")
      if item.checked
        all_unchecked = false
        break
    if all_unchecked
      $("#browser-filter-controls").removeClass("hidden")
      $("#browser-select-controls").addClass("hidden")
      $("#browser-select-all").prop("checked", false)

@delete_selected_orders = () ->
  sel = $("#orders-table li label input:checked")
  for order in sel
    order_id = order.id.split("-")[1]
    console.log "deleting "+order_id
    $.ajax "/orders/"+order_id,
      type: "DELETE"
      async: false
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
        show_error('Could not delete order '+order_id)
      success: (data, textStatus, jqXHR) ->
        console.log "Successful AJAX call"
        window.location = "/pages/browser"
