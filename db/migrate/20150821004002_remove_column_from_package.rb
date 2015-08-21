class RemoveColumnFromPackage < ActiveRecord::Migration
  def change
    remove_column :packages, :dimensions, :integer
  end
end
