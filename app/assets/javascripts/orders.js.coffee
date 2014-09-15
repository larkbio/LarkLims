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
      console.log data

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

        $("#"+new_id+" div a.browser-list-cell-title-link").html(order.product_name)
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/orders/"+order.id)
        $("#"+new_id+" div div.browser-meta span").html(
            "Ordered "+order.order_age+" ago by <a href='/users/"+order.owner_id+"'>"+order.owner+"</a>")

@load_products = ()  ->
  $.ajax '/products',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"
      console.log data

      i = 0
      $("#products-table").empty()
      for prod in data
        new_prod = $("#list_item_template").clone()
        new_id =  "prod-" + i
        new_prod.attr('id', new_id)
        if i == 0
          $("ul#products-table").html(new_prod)
        else
          new_prod.insertAfter($("ul#products-table").children().last())
        i = i+1

        $("#"+new_id+" div a.browser-list-cell-title-link").html(prod.name)
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/products/"+prod.id)
        $("#"+new_id+" div div.browser-meta span").html(
            "Product created "+prod.product_age+" ago")

@load_users = ()  ->
  $.ajax '/users',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"
      console.log data

      i = 0
      $("#products-table").empty()
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

@unselect_meus = () ->
  $("div.browser-subnav div.browser-links a").removeClass('selected')
  $("#orders-title").addClass('hidden')
  $("#orders-table").addClass('hidden')
  $("#products-table").addClass('hidden')
  $("#users-table").addClass('hidden')
  $("#new-order-button").addClass('hidden')
  $("#new-product-button").addClass('hidden')
  $("#new-user-button").addClass('hidden')

@browser_menu = () ->
  $("#orders-button").click ->
    unselect_meus()
    $("#orders-title").removeClass('hidden')
    $("#orders-table").removeClass('hidden')
    $("#orders-button").addClass('selected')
    $("#new-order-button").removeClass('hidden')
    load_orders()

  $("#products-button").click ->
    unselect_meus()
    $("#products-button").addClass('selected')
    $("#products-table").removeClass('hidden')
    $("#new-product-button").removeClass('hidden')
    load_products()

  $("#users-button").click ->
    unselect_meus()
    $("#users-button").addClass('selected')
    $("#users-table").removeClass('hidden')
    $("#new-user-button").removeClass('hidden')
    load_users()