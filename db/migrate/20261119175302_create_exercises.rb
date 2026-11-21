class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises do |t|
      t.references :workout, null: false, foreign_key: true
      t.string :name, null: false
      t.string :details
      t.integer :xp_reward, default: 5, null: false

      t.timestamps
    end
  end
end
