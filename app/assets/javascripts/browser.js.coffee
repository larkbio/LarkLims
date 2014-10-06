@browser_menu = () ->
  $(document).off('scroll')
  $("#orders-button").click ->
    unselect_meus()
    $("#browser-list-header-tab").removeClass("hidden")
    $("#orders-title").removeClass('hidden')
    $("#orders-table").removeClass('hidden')
    $("#orders-button").addClass('selected')
    $("#new-order-button").removeClass('hidden')
    $("#new-order-table").addClass("hidden")
    $("#browser-select-all").removeClass("hidden")
    $("#browser-filter-controls").removeClass("hidden")
    $("#browser-products-header").addClass("hidden")
    load_orders(1)
    $("#paging-row").removeClass("hidden")

  $("#products-button").click ->
    unselect_meus()
    $("#browser-list-header-tab").removeClass("hidden")
    $("#products-button").addClass('selected')
    $("#products-table").removeClass('hidden')
    $("#new-order-table").addClass("hidden")
    $("#browser-select-all").addClass("hidden")
    $("#browser-filter-controls").addClass("hidden")
    $("#browser-products-header").removeClass("hidden")
    load_products()

  $("#users-button").click ->
    unselect_meus()
    $("#browser-list-header-tab").removeClass("hidden")
    $("#users-button").addClass('selected')
    $("#users-table").removeClass('hidden')
    $("#new-order-table").addClass("hidden")
    $("#browser-filter-controls").addClass("hidden")
    $("#browser-products-header").addClass("hidden")
    $("#browser-select-all").removeClass("hidden")
    load_users()

  $("#product-name-sel").change ->
    opt = $(this).find('option:selected');
    console.log opt
    product_id = opt.val()
    add_product_params(product_id)

  $("#new-order-button").click (event) ->
    new_order_handler(event)
    $("#new-order-button").addClass("hidden")

  $("#new-order-submit-button").click (event) -> new_order_submit_handler(event)

  $("ul#orders-table").delegate("li div.browser-list-cell a.browser-list-cell-title-link", "click", show_order_handler )

  $("#show-order-table").delegate( "div.edit-butt", "click", edit_order_param_handler )

  $("#show-order-table").delegate( "button.button.cancel", "click", cancel_order_param_handler )

  $("#show-order-table").delegate( "button.button.save", "click", save_order_param_handler )

  $("#browser-select-all").click () -> all_orders_toggled()

  $("#delete-order").click () -> delete_selected_orders()

  $("#orders-table").delegate("li label input", "click", order_selected )

@unselect_meus = () ->
  $("#paging-row").addClass("hidden")
  $("div.browser-subnav div.browser-links a").removeClass('selected')
  $("#orders-title").addClass('hidden')
  $("#orders-table").addClass('hidden')
  $("#products-table").addClass('hidden')
  $("#users-table").addClass('hidden')
  $("#new-order-button").addClass('hidden')
  $("#new-product-button").addClass('hidden')
  $("#new-user-button").addClass('hidden')
  $("#show-order-table").addClass('hidden')


