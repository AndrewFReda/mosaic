class CreateMosaics < ActiveRecord::Migration
  def change
    create_table :mosaics do |t|

      t.string  :base_img
      t.string  :comp_imgs_dir
      t.integer :max_comp_imgs

      t.timestamps
    end
  end
end
