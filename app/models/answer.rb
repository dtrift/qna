class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc, created_at: :asc) }

  def set_best!
    current_best = question.answers.find_by(best: true)

    transaction do
      current_best.update!(best: false) if current_best
      update!(best: true)
    end
  end
end
