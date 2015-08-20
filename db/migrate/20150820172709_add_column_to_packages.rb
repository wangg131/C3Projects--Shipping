class AddColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :dimensions, :integer
    remove_column :packages, :height, :float
    remove_column :packages, :width, :float
  end
end
