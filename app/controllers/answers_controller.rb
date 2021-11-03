class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, except: :destroy
  before_action :set_answer, only: :destroy

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@question), notice: "Answer was successfully deleted"
    else
      redirect_to question_path(@question), alert: "You can't delete this answer"
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
