# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@products_button_handle_click = () ->
  unselect_menus()
  $("#products-button").addClass('selected')
  $("#new-order-table").addClass("hidden")
  $("#browser-select-all").addClass("hidden")
  $("#browser-filter-controls").addClass("hidden")

  $("#browser-list-header-tab").removeClass("hidden")
  $("#products-table").removeClass('hidden')
  $("#browser-products-header").removeClass("hidden")
  load_products()

@load_products = ()  ->
  $.ajax '/products',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log "Successful AJAX call"

      i = 0
      $("#products-table").empty()
      for prod in data
        new_prod = $("#list_item_template2").clone()
        new_id =  "prod-" + i
        new_prod.attr('id', new_id)
        if i == 0
          $("ul#products-table").html(new_prod)
        else
          new_prod.insertAfter($("ul#products-table").children().last())
        i = i+1

        $("#"+new_id+" label div.lab").addClass("q"+(prod.id % 12))
        $("#"+new_id+" div a.browser-list-cell-title-link").html(prod.name)
        $("#"+new_id+" div a.browser-list-cell-title-link").attr("href", "/products/"+prod.id)
        $("#"+new_id+" div div.browser-meta span").html(
            "Product created "+prod.product_age+" ago")
