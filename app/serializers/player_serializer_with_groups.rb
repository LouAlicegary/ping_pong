class PlayerSerializerWithGroups < ActiveModel::Serializer

  # The below is now done in the config/initializers folder due to deprecation warning
  # It's needed for Ember to read the data correctly
  # embed :ids, include: true

  attributes :id, :name, :mu, :sigma #, :singles_wins, :singles_losses, :doubles_wins, :doubles_losses

  has_many :groups
  has_many :matches, through: :match_players


end