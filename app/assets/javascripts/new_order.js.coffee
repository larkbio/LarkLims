@new_order_handler = (event) ->
  event.preventDefault()
  delete_product_params()
  $("#show-order-table").addClass('hidden')
  $("#browser-list-header-tab").addClass("hidden")
  $("#orders-table").addClass("hidden")
  $("#products-table").addClass("hidden")
  $("#users-table").addClass("hidden")
  $("#new-order-table").removeClass("hidden")
  $("#product-name-sel").empty()

  $.ajax '/products',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"

      first_product = -1
      i = 0
      for p in data
        opt_str = "<option value=\""+p.id+"\">"+p.name+"</option>"
        if i == 0
          $("#product-name-sel").html(opt_str)
          first_product = p.id
        else
          $("#product-name-sel").append(opt_str)
        i = i+1
      add_product_params(first_product)

@new_order_submit_handler = (event) ->
  event.preventDefault()
  values = $("#new-order-form").serialize()
  $.ajax '/orders',
    type: 'POST',
    data: values,
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "CREATE ORDER AJAX Error: #{textStatus}"

    success: (data, textStatus, jqXHR) ->
      console.log "CREATE ORDER  Successful AJAX call"
      console.log data

      for item in $("#params-holder>dl>dd input")
        param_id = item["name"]
        value = item.value
        $.ajax "/orders/"+data.id+"/product_params/"+param_id,
          async: false,
          type: 'PATCH',
          data: {product_param: { value:  value}},
          dataType: 'json'
          error: (jqXHR, textStatus, errorThrown) ->
            console.log "PATCH ORDER AJAX Error: #{textStatus}"

          success: (data, textStatus, jqXHR) ->
            console.log "PATHCH ORDER  Successful AJAX call"
      window.location.assign( "/pages/browser")

