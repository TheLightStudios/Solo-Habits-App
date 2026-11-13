class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.string :reward_name, null: false
      t.integer :cost, null: false

      t.timestamps
    end
  end
end
