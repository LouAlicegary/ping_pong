class Api::V1::MatchesController < ApplicationController


  def index
    render json: Match.all
  end


  def create
    player = Match.create(prep_create_params)
    render json: player
  end


  def show
    render json: Match.find(prep_show_params), serializer: MatchSerializerWithMatchPlayers
  end


  private

    def prep_create_params
      # params[:player][:mu] = 25
      # params[:player][:sigma] = 25.0/3.0
      # return params.require(:player).permit(:name, :mu, :sigma)
    end


    def prep_show_params
      params.require(:id)
    end


end