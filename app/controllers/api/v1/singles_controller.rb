class Api::V1::SinglesController < ApplicationController


  def index
    if params[:winner]
    else
    end
    render json: SinglesMatch.all
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