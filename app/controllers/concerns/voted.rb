module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote, :unvote]
  end

  def vote
    @vote = @votable.votes.new(vote_params.merge(user: current_user))

    respond_to do |format|
      if @vote.update(votable_rating: @votable.rating)
        format.json { render json: @vote }
      else
        format.json do
          render json: @vote.errors.full_messages + [@votable.id, @vote.votable_type], status: :unprocessable_entity
        end
      end
    end
  end

  def unvote
    @vote = @votable.votes.where(user: current_user).first
    respond_to do |format|
      if @vote
        @vote.destroy
        format.json { render json: {votable_id: @votable.id,
                                    votable_type: @votable.class.to_s,
                                    votable_rating: @votable.rating,
                                    status: 0} }
      else
        format.json do
          render json: ['Vote first!', @votable.id, @votable.class.to_s], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def votable_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = votable_klass.find(params[:id])
  end

  def vote_params
    params.require(:vote).permit(:status)
  end
end
