class AnswersChannel < ApplicationCable::Channel
  def follow
    question = Question.find(params[:question_id])
    stream_for question
  end
end
