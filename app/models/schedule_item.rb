# app/models/schedule_item.rb
class ScheduleItem < ApplicationRecord
  belongs_to :user

  TIME_FORMAT = /\A([01]\d|2[0-3]):[0-5]\d\z/

  validates :title, presence: true, length: { maximum: 80 }
  validates :start_time, format: { with: TIME_FORMAT, message: "precisa estar no formato HH:MM" }
end
