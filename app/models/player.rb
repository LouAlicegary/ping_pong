class Player < ActiveRecord::Base


  has_many :group_memberships
  has_many :groups, through: :group_memberships

  #has_many :singles_matches
  #has_many :doubles_matches


  def singles_matches
    SinglesMatch.where("winner = ? OR loser = ?", self.id, self.id)
  end

  def doubles_matches
    DoublesMatch.where("winner_1 = ? OR winner_2 = ? OR loser_1 = ? OR loser_2 = ?", self.id, self.id, self.id, self.id)
  end


  class << self


    def rankings_list
      player_array = Player.all.order(mu: :desc).as_json

      rank = 0
      cutoff = 5

      cur_time = DateTime.now.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%Y %I:%M%p")
      
      message =  "\n\n```MARKETPLACE HOMES - PING PONG PLAYER RATINGS [as of #{cur_time}]\n" +
                 "=======================================================================\n"

      cut_array = []

      player_array.sort_by! { |h| -h["mu"] }

      player_array.each_with_index do |player, index|
        player_id = Player.find_by(name: player["name"]).id
        sw = SinglesMatch.where(winner: player_id).count
        sl = SinglesMatch.where(loser: player_id).count
        dw = DoublesMatch.where("winner_1 = ? OR winner_2 = ?", player_id, player_id).count
        dl = DoublesMatch.where("loser_1 = ? OR loser_2 = ?", player_id, player_id).count
        
        if (sw+sl+dw+dl >= cutoff)
          rank += 1
          message += "#{(rank).to_s.ljust(2," ")} #{player["name"].upcase.ljust(10," ")}    Singles: #{sw.to_s.rjust(2," ")} - #{sl.to_s.ljust(2," ")}    Doubles: #{dw.to_s.rjust(2," ")} - #{dl.to_s.ljust(2," ")}  (#{player["mu"].round(3).to_s} points)\n"
        else
          cut_array << player["name"]
        end
      end

      message += "\n(Minimum #{cutoff} games to qualify)\nPlayers who didn't qualify: #{cut_array.join(", ")}```"

      return message

    end

  end

end