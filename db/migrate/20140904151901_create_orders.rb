class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.datetime :order_date
      t.string :catalog_number
      t.float :price
      t.integer :quantity
      t.string :units
      t.string :department
      t.text :comment
      t.string :url
      t.string :ordered_from
      t.integer :status
      t.datetime :arrival_date
      t.string :place

      t.references :product, index: true
      t.timestamps
    end

    change_table :product_params do |t|
      t.references :orders, index: true
    end
  end
end
