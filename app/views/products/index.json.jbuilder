json.array!(@products) do |product|
  json.extract! product, :id, :name
  json.product_age time_ago_in_words( product.created_at)
end
