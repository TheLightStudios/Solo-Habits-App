class AddPenaltySystemFields < ActiveRecord::Migration[8.1]
  def change
    add_column :habits, :mandatory, :boolean, default: false, null: false
    add_column :users, :last_penalty_check, :date
  end
end
