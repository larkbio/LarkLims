json.array!(@product_params) do |product_param|
  json.extract! product_param, :id, :key, :name, :paramtype, :description, :constraint, :mandatory, :value
  json.url product_product_param_url(@product, product_param, format: :json)
end
