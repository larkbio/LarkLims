class AddActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean
    change_column_default :users, :admin, false
    change_column_default :users, :active, false
  end
end
