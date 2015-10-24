class Player < ActiveRecord::Base

  # :name, :mu, :sigma

  class << self

    def show_rankings_list
      player_array = Player.all.order(mu: :desc).as_json

      rank = 0
      cutoff = 5

      cur_time = DateTime.now.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%Y%l:%M%p")
      
      puts "\n\nMARKETPLACE HOMES - PING PONG PLAYER RATINGS [as of #{cur_time}] "
      puts "======================================================================="

      player_array.sort_by! { |h| -h["mu"] }

      player_array.each_with_index do |player, index|
        player_id = Player.find_by(name: player["name"]).id
        sw = SinglesMatch.where(winner: player_id).count
        sl = SinglesMatch.where(loser: player_id).count
        dw = DoublesMatch.where("winner_1 = ? OR winner_2 = ?", player_id, player_id).count
        dl = DoublesMatch.where("loser_1 = ? OR loser_2 = ?", player_id, player_id).count
        
        if (sw+sl+dw+dl > cutoff)
          rank += 1
          puts "#{(rank).to_s.ljust(2," ")} #{player["name"].upcase.ljust(10," ")}    Singles: #{sw.to_s.rjust(2," ")} - #{sl.to_s.ljust(2," ")}    Doubles: #{dw.to_s.rjust(2," ")} - #{dl.to_s.ljust(2," ")}  (#{player["mu"].round(3).to_s} points)"
        end
      end

      puts "\n(Minimum #{cutoff} games to qualify)\n\n"

    end

  end

end