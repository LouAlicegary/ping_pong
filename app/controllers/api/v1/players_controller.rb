class Api::V1::PlayersController < ApplicationController


  def index
    render json: Player.all # This is processed by an Active Model serializer in app/serializers
  end


end