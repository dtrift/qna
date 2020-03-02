class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_many :answers
  has_many :links
  has_many :comments
  has_many :files
  belongs_to :user

  def files
    object.files.map do |file|
      { url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end
  end

  def short_title
    object.title.truncate(4)
  end
end
