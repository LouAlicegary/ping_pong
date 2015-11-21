Group.delete_all
Group.create!([
  {id: 1, name: "Drive"},
  {id: 2, name: "Walk"}
])

Player.delete_all
Player.create!([
  {id: 1, name: "abe", mu: "25", sigma: "8.33"},
  {id: 2, name: "boris", mu: "25", sigma: "8.33"},
  {id: 3, name: "carly", mu: "25", sigma: "8.33"},
  {id: 4, name: "diana", mu: "25", sigma: "8.33"},
])

GroupMembership.delete_all
GroupMembership.create!([
  {group_id: 1, player_id: 1},
  {group_id: 1, player_id: 2},
  {group_id: 1, player_id: 3},
  {group_id: 1, player_id: 4},  
  {group_id: 2, player_id: 3},
  {group_id: 2, player_id: 4},
])

DoublesMatch.delete_all
DoublesMatch.create!([
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
  {winner_1: 2, winner_2: 4, loser_1: 1, loser_2: 3},
  {winner_1: 2, winner_2: 4, loser_1: 1, loser_2: 3},
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
])

SinglesMatch.delete_all
SinglesMatch.create!([
  {winner: 1, loser: 2},
  {winner: 1, loser: 4},
  {winner: 1, loser: 2},
  {winner: 3, loser: 4},
  {winner: 3, loser: 1},
  {winner: 4, loser: 3},
])
