json.data do
  json.array!(@orders) do |order|
    json.extract! order, :id, :order_date, :catalog_number, :price, :quantity, :units, :department, :comment, :url, :ordered_from, :status, :arrival_date, :place, :contact, :note
    json.product_id order.product.id
    json.product_name order.product.name
    json.order_age time_ago_in_words( order.created_at)
    json.order_date_fmt order.order_date.strftime("%Y-%m-%d %H:%M:%S")
    json.arrival_date_fmt order.order_date.strftime("%Y-%m-%d %H:%M:%S")
    json.owner order.user.name
    json.owner_id order.user.id
    json.num_opened @num_opened
    json.num_closed @num_closed
    json.url order_url(order, format: :json)
  end
end
json.paging do
  json.pagenum @pagenum
  json.currpage @currpage
  json.pagesize @pagesize
end