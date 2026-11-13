class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :habits, dependent: :destroy
  has_many :completions, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_one_attached :avatar

  validate :avatar_valido

  RANKS = { 1 => "E", 10 => "D", 20 => "C", 35 => "B", 50 => "A", 70 => "S" }.freeze
  LEVEL_UP_BONUS = 50

  def xp_to_next_level
    (100 * (level**1.5)).to_i
  end

  def gain_xp!(amount)
    self.xp += amount
    self.coins += amount
    while xp >= xp_to_next_level
      self.xp -= xp_to_next_level
      self.level += 1
      self.coins += LEVEL_UP_BONUS
    end
    self.rank = RANKS.select { |lvl, _| lvl <= level }.values.last
    save!
  end

  def buy!(reward)
    success = false
    transaction do
      lock!
      if coins >= reward.cost
        update!(coins: coins - reward.cost)
        purchases.create!(reward_name: reward.name, cost: reward.cost)
        success = true
      end
    end
    success
  end

  def current_streak
    dates = completions.select(:completed_on).distinct.order(completed_on: :desc).pluck(:completed_on)
    streak = 0
    day = Date.current
    day -= 1 if dates.first != day
    dates.each do |d|
      break unless d == day
      streak += 1
      day -= 1
    end
    streak
  end

  private

  def avatar_valido
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/png image/jpeg image/webp image/gif])
      errors.add(:avatar, "precisa ser PNG, JPG, WEBP ou GIF")
    end

    if avatar.byte_size > 2.megabytes
      errors.add(:avatar, "precisa ter no máximo 2 MB")
    end
  end
end
