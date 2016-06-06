class Match < ActiveRecord::Base


  has_many :match_players
  has_many :players, through: :match_players

  scope :singles, -> { where(match_type: "singles") }
  scope :doubles, -> { where(match_type: "doubles") }


  class << self


    # Team 1 is the winner, team 2 is the loser
    # TODO: THIS SHOULD BE MADE EXTENSIBLE TO HANDLE FREE FOR ALLS
    def play winner_ids_array, loser_ids_array, win_array = [0,1]

      pre_match_ratings = build_pre_match_rating_array winner_ids_array, loser_ids_array
      post_match_ratings = calculate_post_match_ratings pre_match_ratings, win_array

      # Creates match and match_player records and updates player records with new ratings
      create_match_records winner_ids_array, loser_ids_array, pre_match_ratings, post_match_ratings
      updated_players = update_player_records winner_ids_array, loser_ids_array, pre_match_ratings, post_match_ratings

      return updated_players.as_json
    
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
      def create_match_records winner_array, loser_array, pre_match_ratings, post_match_ratings

        # Create the Match record
        match_type = (winner_array.length > 1) ? "doubles" : "singles"
        match = Match.create({match_type: match_type})

        # Create a MatchPlayer record for each player
        all_ids_array = winner_array + loser_array
        all_ids_array.each_with_index do |player_id, index|
          outcome = (winner_array.include? player_id) ? 1 : 2
          MatchPlayer.create({
            match_id: match.id,
            player_id: player_id,
            outcome: outcome,
            mu_pre: pre_match_ratings[outcome - 1][ (index > 1) ? 1 : 0 ].mu,
            mu_post: post_match_ratings[outcome - 1][ (index > 1) ? 1 : 0 ].mu,
            sigma_pre: pre_match_ratings[outcome - 1][ (index > 1) ? 1 : 0 ].sigma,
            sigma_post: post_match_ratings[outcome - 1][ (index > 1) ? 1 : 0 ].sigma
          })
        end
      
        return match

      end


      # update player records with new ratings
      def update_player_records winner_ids_array, loser_ids_array, pre_match_ratings, post_match_ratings

        new_ratings_array = post_match_ratings[0] + post_match_ratings[1]
        ids_array = winner_ids_array + loser_ids_array
        
        ids_array.each_with_index do |id, index|
          new_rating = new_ratings_array[index]
          Player.find_by(id: id).update({mu: new_rating.mu, sigma: new_rating.sigma})
        end

        return Player.where(id: ids_array)

      end



  end

end