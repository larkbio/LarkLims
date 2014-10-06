# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@load_orders = (page)  ->
  if not page
    page = 1
  $.ajax '/orders?page='+page,
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

        $("#"+new_id+" div a.browser-list-cell-title-link").html(order.comment+" <span class=\"product-label qb"+(order.product_id % 12)+"\">"+order.product_name+"</span>")
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/orders/"+order.id)
        $("#"+new_id+" div div.browser-meta span").html(
            "Ordered "+order.order_age+" ago by <a href='/users/"+order.owner_id+"'>"+order.owner+"</a>")

      console.log paging
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
  item_clicked = event.toElement
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
