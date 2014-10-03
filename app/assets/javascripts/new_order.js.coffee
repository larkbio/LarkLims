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

@delete_product_params = () ->
  $("#new-order-ul li.dynamic").remove()

@add_product_params = (product_id) ->
  $("#product-id-holder").val(product_id)
  $.ajax '/products/'+product_id+'/product_params',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call, product params for product "+product_id
      console.log data

      delete_product_params()

      i = 0
      for param in data
        console.log param.key
        new_param = $("#param-template").children().first().clone()
        new_id =  "par-" + i
        new_param.attr('id', new_id)

        new_param.insertAfter($("#new-order-ul li:first"))
        $("#"+new_id+" span:first").html(param.name)
        $("#"+new_id+" span:nth-child(2) input").attr('id', new_id+"-input")
        $("#"+new_id+" span:nth-child(2) input").attr('name', param.id)
        i = i + 1

      $("#params-holder").addClass("hidden")
      $("#params-holder-new").removeClass("hidden")
      $("#params-holder").remove()
      $("#params-holder-new").attr("id", "params-holder")


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

      for item in $("#new-order-ul li.dynamic span input")

        param_id = item["name"]
        value = item.value
        console.log "setting value "+param_id+" -> "+value+" data_id="+data.id
        $.ajax "/orders/"+data.id+"/product_params/"+param_id,
          async: false,
          type: 'PATCH',
          data: {product_param: { value:  value}},
          dataType: 'json'
          error: (jqXHR, textStatus, errorThrown) ->
            console.log "PATCH ORDER AJAX Error: #{textStatus}"

          success: (data, textStatus, jqXHR) ->
            console.log "PATHCH ORDER  Successful AJAX call"

      window.location = "/pages/browser"

