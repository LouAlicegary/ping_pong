require 'minitest/autorun'

class TestSlackBot < ActiveSupport::TestCase


  def setup

    @valid_slash_command = "/pong"
    @valid_subcommand = "help"

    @invalid_slash_command = "/ping"
    @invalid_subcommand = "halp"

  end


  def test_slackbot_valid
    match_substring = "Here's a list of the commands you can use"
    assert (SlackBot.execute_command @valid_slash_command, @valid_subcommand).include? match_substring
  end


  def test_slackbot_invalid
    match_substring = "Invalid slash command"
    assert (SlackBot.execute_command @invalid_slash_command, @invalid_subcommand).include? match_substring
  end


end