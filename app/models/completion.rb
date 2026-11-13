class Completion < ApplicationRecord
  belongs_to :habit
  belongs_to :user
  validates :completed_on, uniqueness: { scope: :habit_id }

  after_create :reward_user

  private

  def reward_user
    bonus = [ user.current_streak, 10 ].min * 0.05
    xp = (habit.xp_reward * (1 + bonus)).to_i
    user.gain_xp!(xp)
    attr = Habit::CATEGORY_ATTRIBUTES[habit.category]
    user.increment!(attr) if attr
  end
end
