class MatchPlayer < ActiveRecord::Base

  belongs_to :match
  belongs_to :player

  scope :wins, -> { where(outcome: 1) }
  scope :losses, -> { where("outcome > ?", 1) }

  scope :singles, -> { joins(:match).where('matches.match_type' => "singles") }
  scope :doubles, -> { joins(:match).where('matches.match_type' => "doubles") }


end
