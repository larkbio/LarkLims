class AddConstraintToProductParams < ActiveRecord::Migration
  def change
    add_index("product_params", ["key","product_id","order_id"], {name: "index_product_params", unique: true})
  end
end
