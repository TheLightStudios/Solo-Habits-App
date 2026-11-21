# app/models/exercise.rb
class Exercise < ApplicationRecord
  belongs_to :workout
  has_many :exercise_completions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 60 }
  validates :details, length: { maximum: 100 }
  validates :xp_reward, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :xp_within_user_cap, if: :will_save_change_to_xp_reward?

  private

  def xp_within_user_cap
    return unless xp_reward && workout&.user

    cap = workout.user.max_exercise_xp
    errors.add(:xp_reward, "pode valer até #{cap} XP no seu nível atual") if xp_reward > cap
  end
end
