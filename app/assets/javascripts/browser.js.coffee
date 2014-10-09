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
  dd = today.getDate()
  mm = today.getMonth()+1
  yyyy = today.getFullYear()
  if dd<10
    dd = '0'+dd
  if mm < 10
    mm = '0'+mm
  return (yyyy+'/'+mm+'/'+dd)