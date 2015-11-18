DoublesMatch.create!([
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
  {winner_1: 2, winner_2: 4, loser_1: 1, loser_2: 3},
  {winner_1: 2, winner_2: 4, loser_1: 1, loser_2: 3},
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
  {winner_1: 1, winner_2: 3, loser_1: 2, loser_2: 4},
])
Player.create!([
  {name: "abe", mu: "25", sigma: "8.33"},
  {name: "boris", mu: "25", sigma: "8.33"},
  {name: "carly", mu: "25", sigma: "8.33"},
  {name: "diana", mu: "25", sigma: "8.33"},
])
SinglesMatch.create!([
  {winner: 1, loser: 2},
  {winner: 1, loser: 4},
  {winner: 1, loser: 2},
  {winner: 3, loser: 4},
  {winner: 3, loser: 1},
  {winner: 4, loser: 3},
])
