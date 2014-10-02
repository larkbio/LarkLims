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
    $("#new-order-button").addClass("hidden")

  $("#new-order-submit-button").click (event) ->
    new_order_submit_handler(event)

  $("ul#orders-table").delegate("li div.browser-list-cell", "click", show_order_handler )

  $("#show-order-table").delegate( "div.edit-butt", "click", edit_order_param_handler )

  $("#show-order-table").delegate( "button.button.cancel", "click", cancel_order_param_handler )

  $("#show-order-table").delegate( "button.button.save", "click", save_order_param_handler )

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


