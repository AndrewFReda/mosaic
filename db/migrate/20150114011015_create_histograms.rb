class CreateHistograms < ActiveRecord::Migration
  def change
    create_table :histograms do |t|

      t.integer :dominant_hue
      t.belongs_to :picture, index: true
      t.timestamps
    end
    
  end
end