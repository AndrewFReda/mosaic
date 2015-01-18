class CreateMosaics < ActiveRecord::Migration
  def change
    create_table :mosaics do |t|

      t.timestamps
    end
  end
end
