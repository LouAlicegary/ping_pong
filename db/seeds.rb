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

Match.delete_all
MatchPlayer.delete_all

Match.play([1,3],[2,4])
Match.play([1,3],[2,4])
Match.play([2,4],[1,3])
Match.play([2,4],[1,3])
Match.play([1,3],[2,4])
Match.play([1,3],[2,4])

Match.play([1],[2])
Match.play([1],[4])
Match.play([1],[2])
Match.play([3],[4])
Match.play([3],[1])
Match.play([4],[3])


