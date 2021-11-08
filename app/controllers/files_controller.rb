class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    if @file.record_type == "Question"
      @question = Question.find(@file.record_id)
    elsif @file.record_type == "Answer"
      @question = Answer.find(@file.record_id).question
    end

    @file.purge if current_user.author_of?(Object.const_get(@file.record_type).find(@file.record_id))
  end
end
