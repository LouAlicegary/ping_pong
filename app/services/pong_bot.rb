class PongBot < SlackBot


  class << self


    def execute_command pong_command

      if PongBot::Commands.validate_command pong_command

        main_command = pong_command.split(" ").first

        case main_command
          when "help"
            message = PongBot::Commands.help
          when "rank"
            message = PongBot::Commands.rank
          when "match"
            message = PongBot::Commands.match pong_command
          when "player"
            message = PongBot::Commands.player pong_command
        else
          message = PongBot::Messages.invalid_command_message
        end

      else
        message = PongBot::Messages.invalid_command_message
      end

      return message

    end



  end


  class Commands


    class << self


      # Ensures the word after "/pong" in the slack command is a valid command
      def validate_command pong_command
        pong_command_array = pong_command.split(" ")
        subcommand = pong_command_array.first
        
        valid_commands = ["help", "rank", "match", "player"]
        return (pong_command.length > 0) && (valid_commands.include? subcommand)
      end


      def help
        return PongBot::Messages.help_command_message
      end


      def rank
        return Player.rankings_list
      end


      def match pong_command
        
        pong_command_array = pong_command.split(" ")

        if pong_command_array.join(" ").split("/").length == 3 && pong_command_array.include?("beat")
          message = parse_doubles_match pong_command_array
        elsif pong_command_array.length == 4 && pong_command_array[2].downcase == "beat"
          message = parse_singles_match pong_command_array
        else
          message = PongBot::Messages.invalid_match_message
        end 

        return message

      end


      def player pong_command

        pong_command_array = pong_command.split(" ")

        player_subcommand = pong_command_array[1]

        if player_subcommand == "add" && pong_command_array.length == 3
          
          if Player.all.pluck(:name).include? pong_command_array[2]
            message = PongBot::Messages.player_already_exists_message
          else
            Player.create({name: pong_command_array[2], mu: 25, sigma: 25/3})
            message = PongBot::Messages.player_added_message
          end
        
        elsif player_subcommand == "list" && pong_command_array.length == 2
          message = PongBot::Messages.list_players_message
        else
          message = PongBot::Messages.invalid_player_command_message
        end

        return message

      end


      private

        def parse_doubles_match pong_command_array
          
          # chop off the word "match" and only deal w players and the word "beat"
          players_array = pong_command_array[1..-1].join(" ").split("/")
          winner_1 = Player.find_by(name: players_array.first.strip)
          winner_2 = Player.find_by(name: players_array[1].split("beat")[0].strip)
          loser_1 = Player.find_by(name: players_array[1].split("beat")[1].strip)
          loser_2 = Player.find_by(name: players_array[2].strip)
          
          if winner_1 && winner_2 && loser_1 && loser_2
            Match.play_match_by_names({ winner: [winner_1.name,winner_2.name], loser: [loser_1.name,loser_2.name] })
            message = PongBot::Messages.match_recorded_successfully
          else
            message = PongBot::Messages.invalid_player_message
          end

          return message

        end


        def parse_singles_match pong_command_array
          
          winner = Player.find_by(name: pong_command_array[1].to_s)
          loser = Player.find_by(name: pong_command_array[3].to_s)

          if winner && loser
            Match.play_match_by_names({ winner: [winner.name], loser: [loser.name] })
            message = PongBot::Messages.match_recorded_successfully
          else
            message = PongBot::Messages.invalid_player_message
          end

          return message

        end

    end
  
  end

  
  class Messages


    class << self


      def list_players_message
        return "#{Player.all.count} players in the system.\n\n" + 
          "#{Player.all.pluck(:name).join(", ")}"
      end


      def player_added_message
        return "Player added."
      end


      def player_already_exists_message
        return "The player you are trying to create already exists in the database."
      end


      def invalid_player_command_message
        return "Invalid `/pong player` command. Try:\n" +
          "`/pong player add lou` = add player \"lou\" (no spaces in player name allowed)\n" +
          "`/pong player list` = list all players in the system"
      end


      def match_recorded_successfully
        return "Match recorded successfully!\n\nNew Rankings:\n" + Player.rankings_list
      end


      def invalid_command_message
        return "Invalid `/pong` command. Type `/pong help` for a full list of commands."
      end


      def help_command_message
        
        return  "Here's a list of the commands you can use:\n" +
          "get help: `/pong help`\n" +
          "view player rankings: `/pong rank`\n" +
          "record a singles match: `/pong match bobby beat paul`\n" + 
          "record a doubles match: `/pong match susan/amy beat nancy/tina`\n" +
          "add a player to the system: `/pong player add jonathan`\n" +
          "get a list of players: `/pong player list` (useful if you must record a match / add a player)\n"
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
  
    end

  end


end
