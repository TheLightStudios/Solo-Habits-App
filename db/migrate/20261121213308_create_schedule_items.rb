class CreateScheduleItems < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :start_time, null: false
      t.string :title, null: false

      t.timestamps
    end

    add_index :schedule_items, [ :user_id, :start_time ]
  end
end
