class AddConstraintToProducts < ActiveRecord::Migration
  def change
    add_index("products", ["name"], {name: "index_product_on_name", unique: true})
  end
end
