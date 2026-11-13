class Purchase < ApplicationRecord
  belongs_to :user

  validates :reward_name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than: 0 }
end
