class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.references :survivor, foreign_key: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    remove_column :survivors, :latitude
    remove_column :survivors, :longitude
  end
end
