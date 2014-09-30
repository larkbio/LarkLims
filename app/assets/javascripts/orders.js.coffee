# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@load_orders = ()  ->
  $.ajax '/orders',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"

      $("#order-stat-open").html("<i class=\"fa fa-arrow-circle-o-up\"></i> "+data[0].num_opened+" Open")
      $("#order-stat-closed").html("<i class=\"fa fa-check\"></i> "+data[0].num_closed+" Completed")

      i = 0
      $("#orders-table").empty()
      for order in data
        new_order = $("#list_item_template").clone()
        new_id =  "ord-" + i
        new_order.attr('id', new_id)
        if i == 0
          $("ul#orders-table").html(new_order)
        else
          new_order.insertAfter($("ul#orders-table").children().last())
        i = i+1

        $("#"+new_id+" div a.browser-list-cell-title-link").html(order.comment+" ("+order.product_name+")")
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/orders/"+order.id)
        $("#"+new_id+" div div.browser-meta span").html(
            "Ordered "+order.order_age+" ago by <a href='/users/"+order.owner_id+"'>"+order.owner+"</a>")

@unselect_meus = () ->
  $("div.browser-subnav div.browser-links a").removeClass('selected')
  $("#orders-title").addClass('hidden')
  $("#orders-table").addClass('hidden')
  $("#products-table").addClass('hidden')
  $("#users-table").addClass('hidden')
  $("#new-order-button").addClass('hidden')
  $("#new-product-button").addClass('hidden')
  $("#new-user-button").addClass('hidden')
  $("#show-order-table").addClass('hidden')

@delete_product_params = () ->
  $("#param-container>dl.dynamic").remove()

@add_product_params = (product_id) ->
  $("#param-container>dl.dynamic").remove()
  $("#product-id-holder").val(product_id)
  $.ajax '/products/'+product_id+'/product_params',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call, product params for product "+product_id

      $("<div id=\"params-holder-new\" class=\"hidden\"></div>").insertAfter($("#params-holder"))
      i = 0
      for param in data
        console.log param.key
        new_param = $("#param-template").children().first().clone()
        new_id =  "par-" + i
        new_param.attr('id', new_id)
        $("#params-holder-new").append(new_param)
        $("#"+new_id+">dt >label").html(param.name)
        $("#"+new_id+">dd >input").attr('id', new_id+"-input")
        $("#"+new_id+">dd >input").attr('name', param.id)
        $("#"+new_id+">dt >label").attr("for", new_id+"-input")
        i = i + 1

      $("#params-holder").addClass("hidden")
      $("#params-holder-new").removeClass("hidden")
      $("#params-holder").remove()
      $("#params-holder-new").attr("id", "params-holder")

@browser_menu = () ->
  $("#orders-button").click ->
    unselect_meus()
    $("#browser-list-header-tab").removeClass("hidden")
    $("#orders-title").removeClass('hidden')
    $("#orders-table").removeClass('hidden')
    $("#orders-button").addClass('selected')
    $("#new-order-button").removeClass('hidden')
    $("#new-order-table").addClass("hidden")
    load_orders()

  $("#products-button").click ->
    unselect_meus()
    $("#browser-list-header-tab").removeClass("hidden")
    $("#products-button").addClass('selected')
    $("#products-table").removeClass('hidden')
    $("#new-order-table").addClass("hidden")
    load_products()

  $("#users-button").click ->
    unselect_meus()
    $("#browser-list-header-tab").removeClass("hidden")
    $("#users-button").addClass('selected')
    $("#users-table").removeClass('hidden')
    $("#new-order-table").addClass("hidden")
    load_users()

  $("#product-name-sel").change ->
    opt = $(this).find('option:selected');
    console.log opt
    product_id = opt.val()
    add_product_params(product_id)

  $("#new-order-button").click (event) ->
    new_order_handler(event)

  $("#new-order-submit-button").click (event) ->
    new_order_submit_handler(event)

  $("ul#orders-table").delegate("li div.browser-list-cell", "click", show_order_handler )

  $("#show-order-table").delegate( "div.edit-butt", "click", edit_order_param_handler )

  $("#show-order-table").delegate( "button.button.cancel", "click", cancel_order_param_handler )
  $("#show-order-table").delegate( "button.button.save", "click", save_order_param_handler )

