class CreateMosaics < ActiveRecord::Migration
  def change
    create_table :mosaics do |t|

      t.integer :grid_columns
      t.integer :grid_rows

      t.timestamps
    end
  end
end
