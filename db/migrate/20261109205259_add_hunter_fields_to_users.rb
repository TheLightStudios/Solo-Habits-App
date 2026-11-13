class AddHunterFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :level, :integer, default: 1, null: false
    add_column :users, :xp, :integer, default: 0, null: false
    add_column :users, :rank, :string, default: "E", null: false
    add_column :users, :strength, :integer, default: 0, null: false
    add_column :users, :intelligence, :integer, default: 0, null: false
    add_column :users, :vitality, :integer, default: 0, null: false
    add_column :users, :discipline, :integer, default: 0, null: false
  end
end
