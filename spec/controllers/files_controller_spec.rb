require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:another_user) { create(:user) }

    context 'by the author' do
      before { login(author) }

      it 'deletes the attached file' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        file = question.files.first

        expect { delete :destroy, params: { id: file }, format: :js }.to change(question.files, :count).by(-1)
      end
    end

    context 'not by the author' do
      before { login(another_user) }

      it "can't delete the attached file" do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        file = question.files.first

        expect { delete :destroy, params: { id: file }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
