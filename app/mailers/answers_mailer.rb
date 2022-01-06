class AnswersMailer < ApplicationMailer
  def created_answer(answer)
    @answer = answer
    @question = answer.question

    @questions.subscribers.find_each { |subscriber| mail to: subscriber.email }
  end
end
