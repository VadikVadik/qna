class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy]

  after_action :publish_answer, only: :create

  authorize_resource

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    @question = @answer.question
    @answer_id = @answer.id
    @answer.destroy
  end

  private

  def publish_answer
    return if @answer.errors.any?
    AnswersChannel.broadcast_to(
      @question,
      ApplicationController.render(
        partial: 'answers/public_answer',
        locals: { answer: @answer }
      )
    )
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
