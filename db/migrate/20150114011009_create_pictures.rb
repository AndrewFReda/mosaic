class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|

      t.string :name
      t.string :url
      t.belongs_to :user, index: true
      # handles basic form of single table inheritance
      t.string :type

      t.timestamps
    end

    add_attachment :pictures, :image
  end
end
