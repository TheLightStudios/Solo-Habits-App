class CreateCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :completions do |t|
      t.references :habit, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :completed_on

      t.timestamps
    end
  end
end
