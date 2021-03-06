class Api::V1::PlayersController < ApplicationController


  def index
    render json: Player.all, each_serializer: PlayerSerializerWithGroups
  end


  def create
    player = Player.create(prep_create_params)
    render json: player
  end


  def show
    render json: Player.find(prep_show_params), serializer: PlayerSerializerWithGroups, root: :player
  end


  private

    def prep_create_params
      params[:player][:mu] = 25
      params[:player][:sigma] = 25.0/3.0
      return params.require(:player).permit(:name, :mu, :sigma)
    end


    def prep_show_params
      params.require(:id)
    end


end