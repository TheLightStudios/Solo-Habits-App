class CreateExerciseCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_completions do |t|
      t.references :exercise, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :completed_on, null: false

      t.timestamps
    end
    add_index :exercise_completions, [ :exercise_id, :completed_on ], unique: true
  end
end
