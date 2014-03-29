class CurrentVotesController < ApplicationController
  before_action :authenticate_user!

  def report
    init_current_vote
    respond_to do |format|
      format.json do
          @currentVote.score= params.require('score')
          @currentVote.save!
          Vote.create!({room: @currentVote.room, user: @currentVote.user, score: @currentVote.score})
          render json: @currentVote
      end
    end
  end

  def init_current_vote
    param_data = {user_id: current_user.id,room_id: params.require('room_id')}
    @currentVote = CurrentVote.where(param_data).first
    @currentVote = CurrentVote.new(param_data) if @currentVote.nil?
  end

  def current_vote_params
    {
        user: current_user,
        room: params.require('room_id'),
        score: params.require('score'),
    }
  end
end
