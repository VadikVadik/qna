class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_token, only: [:new, :edit]
  skip_forgery_protection

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def new
    @question = current_resource_owner.questions.new
  end

  def edit
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_resource_owner.author_of?(@question)

    if !question_params[:best_answer_id].nil? && !@question.award.nil?
      @question.award.update(owner: @question.best_answer.author)
    end
  end

  def destroy
    if current_resource_owner.author_of?(@question)
      @question.destroy
      render json: { message: "Question was successfully deleted" }
    else
      render json: { message: "You can't delete this question" }
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def set_token
    @token = doorkeeper_token.token
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id,
                                     links_attributes: [:id, :name, :url, :gist, :_destroy],
                                     award_attributes: [:id, :title, :image, :_destroy])
  end
end
