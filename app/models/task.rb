class Task < ApplicationRecord
  # Validations
  validates :title, presence: true, length: { maximum: 100 } # Title must be present and have a maximum length
  validates :description, presence: true, length: { maximum: 500 } # Description must be present and have a maximum length
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } # Email must be present and valid
  validates :completed, inclusion: { in: [true, false] } # Completed must be a boolean value
  validates :position,  presence: true, length: { maximum: 500 }
  validates :todo_time, presence: true
  validate :todo_time_cannot_be_in_the_past

  private

  # Custom validation method to check if todo_time is in the past
  def todo_time_cannot_be_in_the_past
    if todo_time.present? && todo_time < Time.current
      errors.add(:todo_time, "cannot be in the past")
    end
  end
end
