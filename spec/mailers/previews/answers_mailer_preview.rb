# Preview all emails at http://localhost:3000/rails/mailers/answers_mailer
class AnswersMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answers_mailer/created_answer
  def created_answer
    AnswersMailer.created_answer
  end

end
