class PlayerSerializerWithGroups < ActiveModel::Serializer

  # The below is now done in the config/initializers folder due to deprecation warning
  # It's needed for Ember to read the data correctly
  # embed :ids, include: true

  attributes :id, :name, :mu, :sigma, :singles_wins, :singles_losses, :doubles_wins, :doubles_losses

  #has_many :singles_matches
  #has_many :doubles_matches
 
  has_many :groups


  def singles_wins
    object.singles_matches.where("winner = ?", object.id).count
  end


  def singles_losses
    object.singles_matches.where("loser = ?", object.id).count
  end

  
  def doubles_wins
    object.doubles_matches.where("winner_1 = ? OR winner_2 = ?", object.id, object.id).count
  end


  def doubles_losses
    object.doubles_matches.where("loser_1 = ? OR loser_2 = ?", object.id, object.id).count
  end


  def singles_matches
    object.singles_matches.where("winner = ? OR loser = ?", object.id, object.id)
  end


  def doubles_matches
    object.doubles_matches.where("winner_1 = ? OR winner_2 = ? OR loser_1 = ? OR loser_2 = ?", object.id, object.id, object.id, object.id)
  end


end