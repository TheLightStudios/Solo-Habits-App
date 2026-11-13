class CreateRewards < ActiveRecord::Migration[8.1]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :cost, default: 20, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
