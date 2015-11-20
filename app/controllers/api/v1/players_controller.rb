class Api::V1::PlayersController < ApplicationController


  def index
    render json: Player.all # This is processed by an Active Model serializer in app/serializers
  end


  def create
    player = Player.create(prep_create_params)
    render json: player # This is processed by an Active Model serializer in app/serializers
  end


  private

    def prep_create_params
      params[:player][:mu] = 25
      params[:player][:sigma] = 25.0/3.0
      params.require(:player).permit(:name, :mu, :sigma)
    end


end