extends Node

var data_grid: TileMapLayer

var buildings_prototypes: Dictionary
var building_data: Dictionary

func get_building_scene_path(build: String):
  return "res://scenes/placeables/" + build + "/" + build.split("/")[1] + ".tscn"
func get_building_resource_path(build: String):
  return "res://resources/placeables/" + build + ".tres"

func _init() -> void:
  for build in building_names:
    var scene_path = get_building_scene_path(build)
    var resource_path = get_building_resource_path(build)
    buildings_prototypes[build] = load(scene_path)
    building_data[build] = load(resource_path)

enum BuildModes {
  NONE, BUILD, DESTROY
}
enum Gender {MALE, FEMALE}
enum EntranceDirection {
  NORTH, EAST, SOUTH, WEST
}
enum BuildingCategory {
  NONE, ROOM, LUXURY, UTIL, PATH, DECOR
}

var build_mode := BuildModes.NONE

var agents: Array[Agent] = []

var building_names := [
  "none/outer_wall", "none/sand", 
  "luxury/store", 
  "util/restroom", 
  "decor/path"
]

func get_tile_from_global(coord: Vector2):
  return data_grid.local_to_map(data_grid.to_local(coord))
func get_global_from_tile(tile: Vector2i):
  return data_grid.to_global(data_grid.map_to_local(tile))


func _ready() -> void:
  Signals.store_building.connect(store_building)

var buildings: Dictionary
func store_building(build: BuildingTemplate):
  if not buildings.has(build.data.code_name):
    buildings[build.data.code_name] = Array()
  buildings[build.data.code_name].append(build)

enum directions {
  NORTH, EAST, SOUTH, WEST
}

func find_nearest_building(from: Vector2i, search_limit: int):
  ## lookup as a spiral
  var x: int = 0; var y: int = 0
  var dx: int = 0; var dy: int = 0
  var dir := directions.NORTH
  var limit: int = 0
  for i in range(search_limit ** 2):
    if dir == directions.EAST and x >= limit: dir = directions.SOUTH
    elif dir == directions.SOUTH and y >= limit: dir = directions.WEST
    elif dir == directions.WEST and abs(x) >= limit: dir = directions.NORTH
    elif dir == directions.NORTH and abs(y) >= limit: 
      dir = directions.EAST
      limit+=1

    if data_grid.data[Vector2i(x + from.x, y + from.y)].has('is_walkable') and data_grid.data[Vector2i(x + from.x, y + from.y)]['is_walkable']:
      print(data_grid.data[Vector2i(x + from.x, y + from.y)])
      return data_grid.data[Vector2i(x + from.x, y + from.y)].building

    if dir == directions.EAST: dx = 1; dy = 0
    if dir == directions.SOUTH: dx = 0; dy = 1
    if dir == directions.WEST: dx = -1; dy = 0
    if dir == directions.NORTH: dx = 0; dy = -1

    x += dx; y += dy


func click_listener(target: Control, callback = null):
  target.mouse_entered.connect(func():
    target.mouse_default_cursor_shape = target.CURSOR_POINTING_HAND
  )
  target.mouse_exited.connect(func():
    target.mouse_default_cursor_shape = target.CURSOR_ARROW
  )
  if callback: target.pressed.connect(callback)
