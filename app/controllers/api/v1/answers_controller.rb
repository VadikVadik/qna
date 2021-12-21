class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  authorize_resource

  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(author: current_resource_owner))
    if @answer.save
      render json: @answer
    else
      render json: {errors: @answer.errors.full_messages}
    end
  end

  def update
    @answer.update(answer_params) if can?(:update, @answer)
    render json: @answer
  end

  def destroy
    if can?(:destroy, @answer)
      @answer.destroy
      render json: { message: "Answer was successfully deleted" }
    else
      render json: { message: "You can't delete this answer" }
    end
  end

  private

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
