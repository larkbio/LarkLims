@show_order_handler = (event) ->
  event.preventDefault()
  a_clicked = event.toElement
  order_url = a_clicked.href

  $("#browser-list-header-tab").addClass("hidden")
  $("#orders-table").addClass("hidden")
  $("#products-table").addClass("hidden")
  $("#users-table").addClass("hidden")
  $("#show-order-table").removeClass("hidden")

  $.ajax order_url,
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log data
      $("#order-product-txt").html(data.product_name)
      $("#order-description-txt").html(data.comment)
      $("#order-ordered_from-txt").html(data.ordered_from)
      $("#order-price-txt").html(data.price)
      $("#order-quantity-txt").html(data.quantity)
      $("#order-units-txt").html(data.units)
      $("#order-department-txt").html(data.department)
      shorturl = data.url
      maxlen = 45
      if shorturl.length > maxlen
        shorturl = shorturl.substr(0, maxlen)+"..."
      $("#order-url-txt").html(shorturl)
      $("#order-url-txt").attr("href", data.url)

@edit_order_param_handler = (event) ->
  item_clicked = event.toElement
  clicked_id =  item_clicked.parentNode.parentNode.id
  param_name = clicked_id.split('-')[1]
  console.log "editing "+param_name

  $("#order-"+param_name+"-txt").addClass("hidden")
  $("#order-"+param_name+"-edit").removeClass("hidden")
  $("#order-"+param_name+"-button div.control-butt").removeClass("hidden")
  $("#order-"+param_name+"-button div.edit-butt").addClass("hidden")

@cancel_order_param_handler = (event) ->
  item_clicked = event.toElement
  clicked_id =  item_clicked.parentNode.parentNode.id
  param_name = clicked_id.split('-')[1]
  console.log "cancelling "+param_name
  $("#order-"+param_name+"-txt").removeClass("hidden")
  $("#order-"+param_name+"-edit").addClass("hidden")
  $("#order-"+param_name+"-button div.control-butt").addClass("hidden")
  $("#order-"+param_name+"-button div.edit-butt").removeClass("hidden")

@save_order_param_handler = (event) ->
  item_clicked = event.toElement
  clicked_id =  item_clicked.parentNode.parentNode.id
  param_name = clicked_id.split('-')[1]
  console.log "saving "+param_name