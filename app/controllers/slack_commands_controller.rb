class SlackCommandsController < ApplicationController

  before_filter :authenticate_command


  def parse

    full_command = params[:text].to_s
    full_command_array = full_command.split(" ") rescue []
    command = full_command_array.first rescue "" 
    
    if validate_command command
      full_command = params[:text].to_s
      slack_message = execute_slack_command full_command
    else
      slack_message = invalid_command_message
    end

    render json: slack_message

  end


  private


    def authenticate_command
      return params[:team_id] == ENV["SLACK_TEAM_ID"] && params[:command] == "/pong"
    end


    def validate_command command
      valid_commands = ["help", "rank", "match", "player"]
      return (params[:text].to_s.length > 0) && (valid_commands.include? command)
    end


    def execute_slack_command full_command

      full_command_array = full_command.split(" ")
      main_command = full_command_array.first

      case main_command
        when "help"
          message = help_command_message
        when "rank"
          message = parse_rank_command full_command_array
        when "match"
          message = parse_match_command full_command_array
        when "player"
          message = parse_player_command full_command_array
      else
        message = invalid_command_message
      end

      return message

    end


    def invalid_command_message
      return "Invalid `/pong` command. Type `/pong help` for a full list of commands."
    end


    def help_command_message
      
      return  "Here's a list of the commands you can use:\n" +
        "`/pong help` = this command\n" +
        "`/pong rank` = view player rankings\n" +
        "`/pong match player_a beat player_b` = record a singles match\n" + 
        "`/pong match player_a / player_b beat player_c / player_d` = record a doubles match\n" +
        "`/pong player list` = get a list of players (useful if you must record a match / add a player)\n" +
        "`/pong player add player_name` = add a player to the system" 
    
    end


    def parse_rank_command
      return "rank"
    end


    def parse_match_command
        
      if full_command_array.length == 3 && full_command_array[1] == "add"
        message = "valid add player"
      elsif full_command_array.length >= 2 && full_command_array[1] == "list"
        message = "valid list player"
      else
        message = "Invalid `/pong player` command. Try:\n" +
          "`/pong player add lou` = add player \"lou\" (single name is best)\n" +
          "`/pong player list` = list all players in the system"
      end 

      return message

    end


    def parse_player_command full_command_array

      if full_command_array.length == 3 && full_command_array[1] == "add"
        message = "valid add player"
      elsif full_command_array.length >= 2 && full_command_array[1] == "list"
        message = "valid list player"
      else
        message = "Invalid `/pong player` command. Try:\n" +
          "`/pong player add lou` = add player \"lou\" (no spaces in player name allowed)\n" +
          "`/pong player list` = list all players in the system"
      end

      return message

    end

end
