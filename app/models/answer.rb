class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true
  validates :best, inclusion: [true, false]

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
