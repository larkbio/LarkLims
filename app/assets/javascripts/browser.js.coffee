@browser_menu = () ->
  $(document).off('scroll')

  $("#orders-button").click ->
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

  $("#products-button").click ->
    unselect_menus()
    $("#products-button").addClass('selected')
    $("#new-order-table").addClass("hidden")
    $("#browser-select-all").addClass("hidden")
    $("#browser-filter-controls").addClass("hidden")

    $("#browser-list-header-tab").removeClass("hidden")
    $("#products-table").removeClass('hidden')
    $("#browser-products-header").removeClass("hidden")
    load_products()

  $("#users-button").click ->
    unselect_menus()
    $("#users-button").addClass('selected')

    $("#new-order-table").addClass("hidden")
    $("#browser-filter-controls").addClass("hidden")
    $("#browser-products-header").addClass("hidden")
    $("#browser-select-all").addClass("hidden")

    $("#browser-list-header-tab").removeClass("hidden")
    $("#users-table").removeClass('hidden')
    $("#browser-users-header").removeClass("hidden")

    load_users()

  $("#product-name-sel").change ->
    opt = $(this).find('option:selected');
    console.log opt
    product_id = opt.val()
    add_product_params(product_id)

  $("#new-order-button").click (event) ->
    new_order_handler(event)
    $("#paging-row").addClass("hidden")
    $("#new-order-button").addClass("hidden")

  $("#new-order-submit-button").click (event) -> new_order_submit_handler(event)

  $("ul#orders-table").delegate("li div.browser-list-cell a.browser-list-cell-title-link", "click", show_order_handler )

  $("#show-order-table").delegate( "div.edit-butt", "click", edit_order_param_handler )

  $("#show-order-table").delegate( "button.button.cancel", "click", cancel_order_param_handler )

  $("#show-order-table").delegate( "button.button.save", "click", save_order_param_handler )

  $("#browser-select-all").click () -> all_orders_toggled()

  $("#delete-order").click () -> delete_selected_orders()

  $("#orders-table").delegate("li label input", "click", order_selected )

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

@unselect_menus = () ->
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

  $("#browser-users-header").addClass("hidden")
  $("#browser-products-header").addClass("hidden")


