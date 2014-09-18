# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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
