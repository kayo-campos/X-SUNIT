class CreateAbductionReports < ActiveRecord::Migration[5.2]
  def change
    create_table :abduction_reports do |t|
      t.integer :survivor_id
      t.integer :witness_id

      t.timestamps
    end
  end
end
