class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[new create destroy]
  before_action :find_answer, only: %i[destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer successfully added'
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@question), notice: 'Answer successfully deleted'
    else
      render 'questions/show'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
