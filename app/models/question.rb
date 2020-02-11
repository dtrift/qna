class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order best: :desc, created_at: :desc }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true
end
