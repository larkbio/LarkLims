json.extract! @order, :id, :catalog_number, :price, :quantity, :units, :department, :comment, :url, :ordered_from, :status, :place, :created_at, :updated_at, :note, :contact
json.arrival_date @arrival_date
json.order_date @order_date
json.product_name @order.product.name
