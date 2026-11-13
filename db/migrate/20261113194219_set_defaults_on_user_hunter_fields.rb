class SetDefaultsOnUserHunterFields < ActiveRecord::Migration[8.1]
  def up
    # Preenche quem já existe com valores nulos
    User.where(level: nil).update_all(level: 1)
    User.where(xp: nil).update_all(xp: 0)
    User.where(rank: nil).update_all(rank: "E")
    %i[strength intelligence vitality discipline].each do |attr|
      User.where(attr => nil).update_all(attr => 0)
    end

    change_column_default :users, :level, from: nil, to: 1
    change_column_default :users, :xp, from: nil, to: 0
    change_column_default :users, :rank, from: nil, to: "E"
    %i[strength intelligence vitality discipline].each do |attr|
      change_column_default :users, attr, from: nil, to: 0
    end

    change_column_null :users, :level, false
    change_column_null :users, :xp, false
    change_column_null :users, :rank, false
    %i[strength intelligence vitality discipline].each do |attr|
      change_column_null :users, attr, false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
