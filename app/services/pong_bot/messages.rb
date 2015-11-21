module PongBot

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