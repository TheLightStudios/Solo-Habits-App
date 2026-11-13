class SetDefaultsOnHabits < ActiveRecord::Migration[8.1]
  def up
    Habit.where(active: nil).update_all(active: true)
    Habit.where(xp_reward: nil).update_all(xp_reward: 10)

    change_column_default :habits, :active, from: nil, to: true
    change_column_default :habits, :xp_reward, from: nil, to: 10
    change_column_null :habits, :active, false
    change_column_null :habits, :xp_reward, false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
