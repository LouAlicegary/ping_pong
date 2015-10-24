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


    def invalid_player_message
      message = "Invalid player chosen.\n" + 
        "Type `/pong player list` to see a list of all valid players.\n" +
        "If you must add a player, type `/pong player add player_name` (only one-word names allowed)"
    end


    def invalid_match_message
      return "Invalid `/pong match` command. Try:\n" +
        "`/pong match player_a beat player_b` = record a singles match\n" +
        "`/pong match player_a / player_b beat player_c / player_d` = record a doubles match\n"
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


    def parse_rank_command full_command_array
      return Player.rankings_list
    end


    def parse_match_command full_command_array
      
      if full_command_array.join(" ").split("/").length == 3 && full_command_array.include?("beat")
        message = parse_doubles_match full_command_array
      elsif full_command_array.length == 4 && full_command_array[2].downcase == "beat"
        message = parse_singles_match full_command_array
      else
        message = invalid_match_message
      end 

      return message

    end


    def parse_doubles_match full_command_array
      
      # chop off the word "match" and only deal w players and the word "beat"
      players_array = full_command_array[1..-1].join(" ").split("/")
      winner_1 = Player.find_by(name: players_array.first.strip)
      winner_2 = Player.find_by(name: players_array[1].split("beat")[0].strip)
      loser_1 = Player.find_by(name: players_array[1].split("beat")[1].strip)
      loser_2 = Player.find_by(name: players_array[2].strip)
      
      if winner_1 && winner_2 && loser_1 && loser_2
        Match.play_match_by_names({ winner: [winner_1.name,winner_2.name], loser: [loser_1.name,loser_2.name] })
        message = "Match recorded successfully!\n\nNew Rankings:\n" + Player.rankings_list
      else
        message = invalid_player_message
      end

      return message

    end


    def parse_singles_match full_command_array
      
      winner = Player.find_by(name: full_command_array[1].to_s)
      loser = Player.find_by(name: full_command_array[3].to_s)

      if winner && loser
        Match.play_match_by_names({ winner: [winner.name], loser: [loser.name] })
        message = "Match recorded successfully!\n\nNew Rankings:\n" + Player.rankings_list
      else
        message = invalid_player_message
      end

      return message

    end


    def parse_player_command full_command_array

      if full_command_array.length == 3 && full_command_array[1] == "add"
        if Player.all.pluck(:name).include? full_command_array[2]
          message = "The player you are trying to create already exists in the database."
        else
          Player.create({name: full_command_array[2], mu: 25, sigma: 25/3})
          message = "Player added."
        end
      elsif full_command_array.length >= 2 && full_command_array[1] == "list"
        message = "#{Player.all.count} players in the system.\n\n" + 
          "#{Player.all.pluck(:name).join(", ")}"
      else
        message = "Invalid `/pong player` command. Try:\n" +
          "`/pong player add lou` = add player \"lou\" (no spaces in player name allowed)\n" +
          "`/pong player list` = list all players in the system"
      end

      return message

    end

end
