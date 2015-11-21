module PongBot  

  class Commands

    class << self


      # Ensures the word after "/pong" in the slack command is a valid command
      def validate_command pong_command
        pong_command_array = pong_command.split(" ")
        subcommand = pong_command_array.first
        
        valid_commands = ["help", "rank", "match", "player"]
        return (pong_command.length > 0) && (valid_commands.include? subcommand)
      end


      # Displays the help message with a list of all available commands
      def help
        return PongBot::Messages.help_command_message
      end


      # Displays a list of player rankings
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


    end # self

  end # class

end # module