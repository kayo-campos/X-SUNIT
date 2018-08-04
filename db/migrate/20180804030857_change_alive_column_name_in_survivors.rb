class ChangeAliveColumnNameInSurvivors < ActiveRecord::Migration[5.2]
  def change
    rename_column :survivors, :alive, :abducted
  end
end
