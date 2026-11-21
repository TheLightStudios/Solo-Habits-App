class AddAttributePointsToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :attribute_points, :integer, default: 0, null: false
    # Quem já subiu de nível recebe os pontos retroativos (3 por nível acima do 1)
    execute "UPDATE users SET attribute_points = (level - 1) * 3"
  end

  def down
    remove_column :users, :attribute_points
  end
end
