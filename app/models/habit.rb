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
  validates :xp_reward, numericality: { only_integer: true, in: 5..50 }

  scope :active, -> { where(active: true) }

  def done_today?
    completions.exists?(completed_on: Date.current)
  end
end
