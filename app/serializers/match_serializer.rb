class MatchSerializer < ActiveModel::Serializer

  # The below is now done in the config/initializers folder due to deprecation warning
  # It's needed for Ember to read the data correctly
  # embed :ids, include: true

  attributes :id, :match_type

  has_many :match_players
  has_many :players, through: :match_players

end