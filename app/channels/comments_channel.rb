class CommentsChannel < ApplicationCable::Channel
  def follow
    question = Question.find(params[:question_id])
    stream_for question

    question.answers.each { |answer| stream_for answer }
  end
end
