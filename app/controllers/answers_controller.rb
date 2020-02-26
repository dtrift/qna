class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[update destroy best]
  before_action :init_new_comment, only: %i[create update best]

  after_action :publish_answer, only: %i[create]

  authorize_resource
  
  def create
    @answer = @question.answers.build(answer_params.merge(question: @question))
    @answer.user = current_user

    if @answer.save
      flash.now[:notice] = 'Answer successfully added'
    end
  end

  def update
    @question = @answer.question

    if current_user.author?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Answer successfully edited'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      
      flash.now[:notice] = 'Answer successfully deleted'
    else
      render 'questions/show'
    end
  end

  def best
    if current_user.author?(@answer.question)
      @answer.set_best!

      flash.now[:notice] = 'Answer set as best'
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:id, :name, :url, :_destroy])
  end

  def answer_files
    @answer.files.map do |file|
          {
            id: file,
            name: file.filename.to_s,
            url: url_for(file) 
          }
    end
  end

  def publish_answer
    return if @answer.errors.present?

    ActionCable.server.broadcast(
      "question-#{@question.id}-answers",
        answer: @answer,
        question_author: @answer.question.user,
        files: answer_files,
        links: @answer.links
        )
  end

  def init_new_comment
    @comment = Comment.new
  end
end
