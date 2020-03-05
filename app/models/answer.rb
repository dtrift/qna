class Answer < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true
  validates :best, inclusion: [true, false]

  after_save :notify_author_of_question

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)

      question.badge&.update!(user: user)
    end
  end

  private

  def notify_author_of_question
    NewAnswerDigestJob.perform_later(self)
  end
end
