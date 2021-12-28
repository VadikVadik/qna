class QuestionSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    Question.find(params[:question_id]).subscribers.push(current_user)
  end

  def destroy
    QuestionSubscription.find(params[:id]).destroy
  end

  private

  def question_params
    params.require(:question_subscription).permit(:question_id)
  end
end
