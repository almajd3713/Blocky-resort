extends Node

var data_grid: TileMapLayer

enum BuildModes {
  NONE, BUILD, DESTROY
}
var build_mode := BuildModes.NONE

var agents: Array[Agent] = []

var building_names := [
  "store", 
  "decor/outer_wall", "decor/path", "decor/sand"
]