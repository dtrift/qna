class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index show create]

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    @answer = @question.answers.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: 201
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
