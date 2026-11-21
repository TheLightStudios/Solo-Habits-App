# app/models/workout.rb
class Workout < ApplicationRecord
  belongs_to :user
  has_many :exercises, dependent: :destroy

  validates :name, presence: true, length: { maximum: 60 }
end
