class SlackBot

  class << self


    def execute_command slash_command, command_details
      
      return SlackBot::Messages.invalid_slash_command unless validate_slash_command slash_command

      return parse_and_execute_slash_command slash_command, command_details 

    end  


    private


      # Ensures the word after "/pong" in the slack command is a valid command
      def validate_slash_command command
        valid_commands = ["/pong"]
        return valid_commands.include? command
      end


      def parse_and_execute_slash_command slash_command, command_details
        if slash_command == "/pong"
          return PongBot.execute_command command_details
        else
          return SlackBot::Messages.invalid_slash_command
        end
      end


  end


  class Messages

    class << self

      def invalid_slash_command
        return "Invalid slash command. Try again."
      end

    end


  end


end