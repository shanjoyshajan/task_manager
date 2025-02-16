class Task < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  validates :status, inclusion: { in: statuses.keys, message: "must be one of: #{statuses.keys.join(', ')}" }
  validates :due_date, presence: true
end
