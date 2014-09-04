json.array!(@orders) do |order|
  json.extract! order, :id, :order_date, :catalog_number, :price, :quantity, :units, :department, :comment, :url, :ordered_from, :status, :arrival_date, :place
  json.url order_url(order, format: :json)
end
