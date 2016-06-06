class Player < ActiveRecord::Base


  has_many :group_memberships
  has_many :groups, through: :group_memberships

  has_many :match_players
  has_many :matches, through: :match_players



  def singles_wins
    match_players.singles.wins
  end


  def singles_losses
    match_players.singles.losses
  end

  
  def doubles_wins
    match_players.doubles.wins
  end


  def doubles_losses
    match_players.doubles.losses
  end


  def singles_matches
    matches.singles
  end


  def doubles_matches
    matches.doubles
  end



end