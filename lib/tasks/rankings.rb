namespace :rankings do
  
  desc "Import matches"
  task import_matches: :environment do
    
    Competition.build_initial_rankings
  
  end

end