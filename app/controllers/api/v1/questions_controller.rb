class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      render json: {errors: @question.errors.full_messages}
    end
  end

  def update
    @question.update(question_params)

    if !question_params[:best_answer_id].nil? && !@question.award.nil?
      @question.award.update(owner: @question.best_answer.author)
    end

    render json: @question
  end

  def destroy
    @question.destroy
    render json: { message: "Question was successfully deleted" }
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id,
                                     links_attributes: [:id, :name, :url, :gist, :_destroy],
                                     award_attributes: [:id, :title, :image, :_destroy])
  end
end
