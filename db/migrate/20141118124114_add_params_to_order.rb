class AddParamsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :contact, :string
    add_column :orders, :note, :string
  end
end
