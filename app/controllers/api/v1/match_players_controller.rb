class Api::V1::MatchPlayersController < ApplicationController


  def index
    render json: MatchPlayer.all, root: :matchplayers
  end


  def create
    mp = MatchPlayer.create(prep_create_params)
    render json: mp
  end


  def show
    render json: MatchPlayer.find(prep_show_params)
  end


  private


    def prep_create_params
      return params.require(:group).permit(:name)
    end


    def prep_show_params
      params.require(:id)
    end


end



