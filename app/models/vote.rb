class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :score, presence: true
  validates :score, inclusion: [-1, 1]
  validates_numericality_of :score, only_integer: true
end
