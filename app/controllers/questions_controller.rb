class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
      @answer = user_signed_in? ? current_user.answers.new() : Answer.new
      @answer.links.build
      @best_answer = @question.best_answer
		  @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = current_user.questions.new
    @question.links.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if !question_params[:best_answer_id].nil? && !@question.award.nil?
      @question.award.owner = Answer.find(question_params[:best_answer_id]).author
    end

    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted'
    else
      render :show, notice: "You can't delete this question"
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     award_attributes: [:id, :title, :image, :_destroy])
  end
end
