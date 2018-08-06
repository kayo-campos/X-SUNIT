class CreateAuxiliaryCounters < ActiveRecord::Migration[5.2]
  def change
    create_table :auxiliary_counters do |t|
      t.string :label
      t.integer :count

      t.timestamps
    end
  end
end
