class SearchController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:search_params] == 'all'
      @results = ThinkingSphinx.search params[:query]
    else
      @results = params[:search_params].classify.constantize.search params[:query]
    end

    @questions = []
    @answers = []
    @comments = []
    @users = []

    @results.each do |result|
      @questions << result if result.class == Question
      @answers << result if result.class == Answer
      @comments << result if result.class == Comment
      @users << result if result.class == User
    end

    render :show, locals: { questions: @questions,
                            answers: @answers,
                            comments: @comments,
                            users: @users}
  end

  def show
  end
end
