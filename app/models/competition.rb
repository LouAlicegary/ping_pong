class Competition

  class << self


    def build_initial_rankings
      
      limit = 100

      all_mus = []
      all_sigmas = []

      # Build sigma and mu arrays (containing all players) after randomizing the initial match order
      limit.times do |index|
        puts "Randomizing match order - attempt #{index+1} of #{limit}"
        all_players = parse_initial_match_schedule(initial_match_schedule.shuffle)
        all_players.each do |record|
          all_mus.push({name: record["name"], value: record["mu"]})
          all_sigmas.push({name: record["name"], value: record["sigma"]})
        end
      end

      # pull all players from the above arrays, figure out average mu and sigma for each and build a player table
      player_name_array = all_mus.pluck(:name).uniq
      player_name_array.each do |p_name|
        
        mu_array = all_mus.select{|h| h[:name] == p_name}.map{|h| h[:value]}.flatten
        mu_avg = mu_array.inject{ |sum, el| sum + el }.to_f / mu_array.size

        sigma_array = all_sigmas.select{|h| h[:name] == p_name}.map{|h| h[:value]}.flatten
        sigma_avg = sigma_array.inject{ |sum, el| sum + el }.to_f / sigma_array.size

        Player.create({name: p_name, mu: mu_avg, sigma: sigma_avg})

      end

      Player.display_rankings_list

      return 1

    end


  end


  private


    # Format of match schedule is 
    # [{ winner: ["nick"], loser: ["andy"] },{ winner: ["lou","jacob"], loser: ["dustin","tobe"] }, ...]
    def parse_initial_match_schedule(incoming = Competition.initial_match_schedule)

      all_records = []

      incoming = [incoming] if incoming.class == Hash
      incoming.each do |match|
        all_records = match.play_match_by_names match
      end

      return all_records

    end


    # Format of match schedule is 
    # [{ winner: ["nick"], loser: ["andy"] },{ winner: ["lou","jacob"], loser: ["dustin","tobe"] }, ...]
    def initial_match_schedule
      return []
    end


end
