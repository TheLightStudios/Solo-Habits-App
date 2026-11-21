# app/models/exercise_completion.rb
class ExerciseCompletion < ApplicationRecord
  belongs_to :exercise
  belongs_to :user

  validates :completed_on, uniqueness: { scope: :exercise_id }

  after_create :reward_user

  private

  def reward_user
    user.gain_xp!(exercise.xp_reward)
  end
end
