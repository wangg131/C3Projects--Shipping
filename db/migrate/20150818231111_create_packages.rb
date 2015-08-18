class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.float :weight
      t.float :height
      t.float :width

      t.timestamps null: false
    end
  end
end
