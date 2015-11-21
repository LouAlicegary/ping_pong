class DoublesMatchSerializer < ActiveModel::Serializer

  # The below is now done in the config/initializers folder due to deprecation warning
  # It's needed for Ember to read the data correctly
  # embed :ids, include: true

  attributes :id, :winner_1, :winner_2, :loser_1, :loser_2

end