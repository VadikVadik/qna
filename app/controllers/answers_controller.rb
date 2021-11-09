class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy]

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    @question = @answer.question

    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @question = @answer.question
    @answer_id = @answer.id

    @question.update(best_answer_id: nil) if @answer.best?
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
