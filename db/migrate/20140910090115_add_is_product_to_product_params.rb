class AddIsProductToProductParams < ActiveRecord::Migration
  def change
    add_column :product_params, :is_product, :boolean, default: true
  end
end
