require 'test_helper'
require 'minitest/autorun'

# Inheriting from Minitest::Test doesn't allow me to access fixtures
class TestPongBot < ActiveSupport::TestCase


  def setup

    @valid_slash_command = "/pong"

    @player_a = players(:abe).name
    @player_b = players(:boris).name
    @player_c = players(:carly).name
    @player_d = players(:diana).name
    @player_e = players(:esther).name

    @fake_player = "garbage"

  end


  def test_pongbot_help
    command = "help"
    match_substring = "Here's a list of the commands you can use"
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


  def test_pongbot_singles_match
    command = "match #{@player_a} beat #{@player_b}"
    match_substring = "Match recorded successfully!"
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


  def test_pongbot_doubles_match
    command = "match #{@player_a} / #{@player_b} beat #{@player_c} / #{@player_d}"
    match_substring = "Match recorded successfully!"
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


  def test_invalid_matches
    command = "match #{@player_a} beat #{@fake_player}"
    match_substring = "Invalid player chosen."
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


  def test_pongbot_player
    command = "player list"
    match_substring = "in the system"
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


  def test_pongbot_rank
    command = "rank"
    match_substring = "RATINGS"
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


  def test_pongbot_invalid
    command = "garbage"
    match_substring = "Invalid `/pong` command"
    assert_equal true, ((PongBot.execute_command command).include? match_substring)
  end


end