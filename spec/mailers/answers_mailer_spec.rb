require "rails_helper"

RSpec.describe AnswersMailer, type: :mailer do
  describe "created_answer" do
    let(:mail) { AnswersMailer.created_answer }

    it "renders the headers" do
      expect(mail.subject).to eq("Created answer")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
