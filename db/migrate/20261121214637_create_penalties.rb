class CreatePenalties < ActiveRecord::Migration[8.1]
  def change
    create_table :penalties do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :habit_id, null: false
      t.string :habit_name, null: false
      t.date :penalty_date, null: false
      t.integer :xp_lost, default: 0, null: false
      t.integer :coins_lost, default: 0, null: false

      t.timestamps
    end

    add_index :penalties, [ :user_id, :habit_id, :penalty_date ], unique: true
  end
end
