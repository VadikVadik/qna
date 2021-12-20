class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_token, only: [:new, :edit]
  skip_forgery_protection

  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def new
    @answer = @question.answers.new(author: current_resource_owner)
  end

  def edit
  end

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_resource_owner))
    render json: @answer
  end

  def update
    @answer.update(answer_params) if current_resource_owner.author_of?(@answer)
  end

  def destroy
    @question = @answer.question
    @answer_id = @answer.id

    @question.update(best_answer_id: nil) if @answer.best?
    @answer.destroy if current_resource_owner.author_of?(@answer)
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_token
    @token = doorkeeper_token.token
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
