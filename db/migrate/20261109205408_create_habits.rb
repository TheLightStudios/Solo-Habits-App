class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :category
      t.integer :xp_reward, default: 10, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
