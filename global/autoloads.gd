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
  # var X = from.x; var Y = from.y
  # var x = X; var y = Y
  # var dx = 0; var dy = -1
  # for i in range(max(X, Y) ** 2):
  #   # print("-", X,"/2 < ",x," and ",x," <= ", X," /2: ", -X/2 < x and x <= X/2)
  #   # print("-", Y,"/2 < ",y," and ",y," <= ", Y," /2: ", -Y/2 < y and y <= Y/2)
  #   print(-X/2 ,"<", x ," and ", x ,"<=", X/2, " : ", -X/2 < x and x <= X/2)
  #   print(-Y/2 ,"<", x ," and ", x ,"<=", Y/2, " : ", -Y/2 < Y + x and x <= Y/2)

  #   if(-X/2 < X + x and X + x <= X/2) and (-Y/2 < Y + y and Y + y <= Y/2):
  #     if data_grid.data[Vector2i(x, y)]['is_walkable']:
  #       print("Found! ", data_grid.data[Vector2i(X + x, Y + y)]['building'])
  #       return data_grid.data[Vector2i(X + x, Y + y)]['building']
  #   if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y):
  #     dx = -dy; dy = dx
  #   x = x + dx; y = y + dy