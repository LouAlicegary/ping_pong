class Match

  class << self

    include TrueSkill::TrueSkillGeneral


    # Team 1 is the winner, team 2 is the loser
    def play_match_by_rankings team1, team2, win_array = [0,1]
      
      team1_ratings = team1.map{|h| h[:rating]}
      team2_ratings = team2.map{|h| h[:rating]}
      
      results_array = g.transform_ratings([team1_ratings, team2_ratings], win_array)
      ratings_array = results_array[0].concat results_array[1]
      names_array = team1.concat(team2).map{|h| h[:name]}

      # update player record with new ratings
      names_array.each_with_index do |name, index|
        this_rating = ratings_array[index]
        Player.find_by(name: name).update({mu: this_rating.mu, sigma: this_rating.sigma})
      end

      return Player.all.as_json
    
    end

    # output hash format { winner: [{name: "Lou", rating: [#<Rating>..]}, {...}], loser: [{...}] }
    def convert_name_match_to_rating_match match_hash
      
      winner_array = match_hash[:winner]
      loser_array = match_hash[:loser]

      # convert arrays of plaintext names to player ratings
      return convert_name_arrays_to_rating_arrays winner_array, loser_array

    end


    # match hash format: { winner: ["Lou","Jacob"], loser: ["Dustin","Tobe"] }
    def play_match_by_names match
      
      # output hash format { winner: [{name: "Lou", rating: [#<Rating>..]}, {...}], loser: [{...}] }
      ratings_match_hash = Match.convert_name_match_to_rating_match match

      # create a SinglesMatch or DoublesMatch record for the match data
      create_match_record ratings_match_hash[:winner], ratings_match_hash[:loser]

      # update player records based on match results
      all_players_post = Match.play_match_by_rankings ratings_match_hash[:winner], ratings_match_hash[:loser]
    
      return all_players_post

    end


    private

      def convert_name_arrays_to_rating_arrays winner_array, loser_array

        new_winner_array = []
        new_loser_array = []

        winner_array.each do |w|
          player = Player.find_by(name: w.downcase)
          new_winner_array.push({name: w.downcase, rating: TrueSkill::Rating.new(player.mu, player.sigma)}) if player
        end

        loser_array.each do |w|
          player = Player.find_by(name: w.downcase)
          new_loser_array.push({name: w.downcase, rating: TrueSkill::Rating.new(player.mu, player.sigma)}) if player
        end

        return { winner: new_winner_array, loser: new_loser_array }

      end


      # create a SinglesMatch or DoublesMatch record for the match data
      def create_match_record winner_array, loser_array

        if winner_array.length > 1
          w1 = Player.find_by(name: winner_array[0][:name]).id
          w2 = Player.find_by(name: winner_array[1][:name]).id
          l1 = Player.find_by(name: loser_array[0][:name]).id
          l2 = Player.find_by(name: loser_array[1][:name]).id
          DoublesMatch.create({winner_1: w1, winner_2: w2, loser_1: l1, loser_2: l2})
        else
          w = Player.find_by(name: winner_array[0][:name]).id
          l = Player.find_by(name: loser_array[0][:name]).id
          SinglesMatch.create({winner: w, loser: l})
        end
      
      end

  end

end