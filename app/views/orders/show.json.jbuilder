json.extract! @order, :id, :order_date, :catalog_number, :price, :quantity, :units, :department, :comment, :url, :ordered_from, :status, :place, :created_at, :updated_at
json.arrival_date @arrival_date
json.product_name @order.product.name
