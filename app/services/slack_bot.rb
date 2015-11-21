module SlackBot


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
          bot_class = PongBot
          return bot_class.execute_command command_details
        else
          return SlackBot::Messages.invalid_slash_command
        end
      end


  end


end