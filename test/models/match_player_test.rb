require "test_helper"

describe MatchPlayer do
  let(:match_player) { MatchPlayer.new }

  it "must be valid" do
    value(match_player).must_be :valid?
  end
end
