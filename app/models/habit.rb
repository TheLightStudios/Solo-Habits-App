class Habit < ApplicationRecord
  belongs_to :user
  has_many :completions, dependent: :destroy

  CATEGORY_ATTRIBUTES = {
    "treino" => :strength,
    "estudo" => :intelligence,
    "saude"  => :vitality,
    "rotina" => :discipline
  }.freeze

  validates :name, presence: true, length: { maximum: 60 }
  validates :category, inclusion: { in: CATEGORY_ATTRIBUTES.keys }
  validates :xp_reward, numericality: { only_integer: true, greater_than_or_equal_to: 5 }
  validate :xp_within_user_cap, if: :will_save_change_to_xp_reward?

  scope :active, -> { where(active: true) }

  def done_today?
    completions.exists?(completed_on: Date.current)
  end

  def penalty_amount
    [ (xp_reward * User::PENALTY_RATE).round, 1 ].max
  end

  private

  def xp_within_user_cap
    return unless xp_reward && user

    cap = user.max_task_xp
    errors.add(:xp_reward, "pode valer até #{cap} XP no seu nível atual") if xp_reward > cap
  end
end
