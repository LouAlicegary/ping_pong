class Api::V1::GroupsController < ApplicationController


  def index
    render json: Group.all
  end


  def create
    group = Group.create(prep_create_params)
    render json: group
  end


  def show
    render json: Group.find(prep_show_params), serializer: GroupSerializerWithPlayers, root: :group
  end


  private


    def prep_create_params
      return params.require(:group).permit(:name)
    end


    def prep_show_params
      params.require(:id)
    end


end