class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy


  def author?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    votes.exists?(voteable_id: resource)
  end
end
