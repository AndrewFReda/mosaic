class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|

      t.belongs_to :user
      t.string :name

      t.timestamps
    end

    add_attachment :pictures, :image
    add_index :pictures, :user_id
  end
end
