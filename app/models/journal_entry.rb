class JournalEntry < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 500 }
  validates :entry_date, presence: true, uniqueness: { scope: :user_id }
end
