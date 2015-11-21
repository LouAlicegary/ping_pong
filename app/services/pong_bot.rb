module PongBot


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



end
