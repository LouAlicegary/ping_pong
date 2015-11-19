class Api::V1::SlackCommandsController < ApplicationController


  before_action :authenticate_command


  def parse

    slash_command = params[:command].to_s
    command_details = params[:text].to_s
    
    slack_message = SlackBot.execute_command slash_command, command_details

    render json: slack_message

  end


  private


    # Used to ensure there's a slack token provided and that the command starts with the correct syntax
    def authenticate_command
      render json: {error: "Invalid Slack token."}, status: 404 unless params[:token] == ENV["SLACK_TOKEN"]
    end


end
