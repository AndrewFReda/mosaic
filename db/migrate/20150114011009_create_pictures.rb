class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|

      t.string :name
      t.integer :composition_id
      t.integer :base_id
      t.integer :mosaic_id

      t.timestamps
    end

    add_attachment :pictures, :image
  end
end
