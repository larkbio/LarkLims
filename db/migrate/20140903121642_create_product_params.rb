class CreateProductParams < ActiveRecord::Migration
  def change
    create_table :product_params do |t|
      t.string :key
      t.string :name
      t.string :paramtype
      t.string :description
      t.string :constraint
      t.boolean :mandatory
      t.text :value

      t.references :product, index: true

      t.timestamps
    end
  end
end
