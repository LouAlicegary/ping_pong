class Match < ActiveRecord::Base

  class << self


    # Team 1 is the winner, team 2 is the loser
    # TODO: THIS SHOULD BE MADE EXTENSIBLE TO HANDLE FREE FOR ALLS
    def play winner_ids_array, loser_ids_array, win_array = [0,1]

      pre_match_ratings = build_pre_match_rating_array winner_ids_array, loser_ids_array
      post_match_ratings = calculate_post_match_ratings pre_match_ratings, win_array

      # Creates match and match_player records and updates player records with new ratings
      create_match_record winner_ids_array, loser_ids_array, pre_match_ratings, post_match_ratings
      updated_players = update_player_records winner_ids_array, loser_ids_array, pre_match_ratings, post_match_ratings

      return updated_players.as_json
    
    end


    # match hash format: { winner: ["Lou","Jacob"], loser: ["Dustin","Tobe"] }
    def play_match_by_names match
      
      player_ids = convert_name_arrays_to_id_arrays match

      all_players_post_match = Match.play player_ids[:winner], player_ids[:loser]
    
      return all_players_post_match

    end


    private


      def build_pre_match_rating_array winner_ids_array, loser_ids_array
        
        winner_rating_array = []
        loser_rating_array = []

        winner_ids_array.each do |player_id|
          player = Player.find_by(id: player_id)
          winner_rating_array.push(TrueSkill::Rating.new(player.mu, player.sigma)) if player
        end

        loser_ids_array.each do |player_id|
          player = Player.find_by(id: player_id)
          loser_rating_array.push(TrueSkill::Rating.new(player.mu, player.sigma)) if player
        end
        
        return [winner_rating_array, loser_rating_array]

      end


      # This method can take singles, doubles, or free-for-alls
      def calculate_post_match_ratings pre_match_ratings, win_array
        
        ts = TrueSkill::TrueSkill.new
        post_match_ratings = ts.transform_ratings(pre_match_ratings, win_array)

        return post_match_ratings

      end


      # create a SinglesMatch or DoublesMatch record for the match data
      def create_match_record winner_array, loser_array, pre_match_ratings, post_match_ratings

        if winner_array.length > 1
          w1 = winner_array[0]
          w2 = winner_array[1]
          l1 = loser_array[0]
          l2 = loser_array[1]
          match = DoublesMatch.create({winner_1: w1, winner_2: w2, loser_1: l1, loser_2: l2})
        else
          w = winner_array[0]
          l = loser_array[0]
          match = SinglesMatch.create({winner: w, loser: l})
        end
      
        return match

      end


      # update player records with new ratings
      def update_player_records winner_ids_array, loser_ids_array, pre_match_ratings, post_match_ratings

        new_ratings_array = post_match_ratings[0].concat post_match_ratings[1]
        ids_array = winner_ids_array.concat(loser_ids_array)
        
        ids_array.each_with_index do |id, index|
          new_rating = new_ratings_array[index]
          Player.find_by(id: id).update({mu: new_rating.mu, sigma: new_rating.sigma})
        end

        return Player.where(id: ids_array)

      end


      def convert_name_arrays_to_id_arrays match_hash
        
        winner_array = match_hash[:winner].map{|a| Player.find_by(name: a.downcase).id}
        loser_array = match_hash[:loser].map{|a| Player.find_by(name: a.downcase).id}

        return { winner: winner_array, loser: loser_array }

      end



  end

end