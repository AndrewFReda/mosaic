class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :email
      t.string :password_digest, null: false
      
      t.timestamps
    end
  end
end
