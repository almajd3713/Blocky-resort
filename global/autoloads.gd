extends Node

var data_grid: TileMapLayer

enum BuildModes {
  NONE, BUILD, DESTROY
}
var build_mode := BuildModes.NONE