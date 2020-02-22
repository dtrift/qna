class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @comment = Comment.new
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_badge
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question successfully created'
    else
      render :new
    end
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
      flash.now[:notice] = 'Question successfully edited'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      render :show
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     badge_attributes: [:name, :image])
  end

  def publish_question
    return if @question.errors.present?

    ActionCable.server.broadcast(
      'question_channel',
      ApplicationController.render(
        partial: 'questions/question', 
        locals: { question: @question }
        )
      )
  end
end
