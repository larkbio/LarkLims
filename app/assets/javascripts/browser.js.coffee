@browser_menu = () ->
  $(document).off('scroll')

  $("#orders-button").click ->
    orders_button_handle_click()

  $("#products-button").click ->
    products_button_handle_click()

  $("#users-button").click ->
    users_button_handle_click()

  bind_order_events()
  bind_show_order_events()
  bind_new_order_events()


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


@get_currdate = () ->
  today = new Date()
  dd = ('0'+today.getDate()).substr(-2)
  mm = ('0'+(today.getMonth()+1)).substr(-2)
  yyyy = today.getFullYear()
  hh = ('0'+today.getHours()).substr(-2)
  mins = ('0'+today.getMinutes()).substr(-2)
  secs = ('0'+today.getSeconds()).substr(-2)
  return (yyyy+'-'+mm+'-'+dd+' '+hh+':'+mins+':'+secs)