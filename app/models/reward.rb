class Reward < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 60 }
  validates :cost, numericality: { only_integer: true, in: 1..10_000 }

  scope :active, -> { where(active: true) }
end
