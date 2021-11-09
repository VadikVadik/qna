class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    if @file.record.instance_of?(Question)
      @question = @file.record
    elsif @file.record.instance_of?(Answer)
      @question = @file.record.question
    end

    @file.purge if current_user.author_of?(@file.record)
  end
end
