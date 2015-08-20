class AddColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :sizing, :string
    add_column :packages, :order_id, :integer
    remove_column :packages, :height, :float
    remove_column :packages, :width, :float
  end
end
