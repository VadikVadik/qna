class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def new
    @answer = @question.answers.new(author_id: current_user.id)
  end

  def create
    params = answer_params
    params[:author_id] = current_user.id
    @answer = @question.answers.new(params)

    if @answer.save
      redirect_to @question
    else
      redirect_to @question, alert: "Body can't be blank"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
