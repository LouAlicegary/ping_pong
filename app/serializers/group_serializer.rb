class GroupSerializer < ActiveModel::Serializer

  # The below is now done in the config/initializers folder due to deprecation warning
  # It's needed for Ember to read the data correctly
  # embed :ids, include: true

  attributes :id, :name

end
