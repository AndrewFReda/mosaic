class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|

      t.belongs_to :user
      t.string :name
      t.string :s3_url

      t.timestamps
    end

    add_index :pictures, :user_id
  end
end
