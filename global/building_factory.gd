extends Node

@export var world: Node2D
@export var building_grid: TileMapLayer

var buildings_prototypes: Dictionary
@onready var data_grid := Data.data_grid


var buildings_names = [
  "store", "decor/outer_wall", "decor/path"
]

var current_placement_building: BuildingTemplate

func _init() -> void:
  for build in buildings_names:
    var full_path = get_building_scene_path(build)
    buildings_prototypes[build] = load(full_path)
  pass;


func _ready() -> void:
  Signals.toggle_build_mode.connect(_toggle_build_mode)
  Signals.toggle_destroy_mode.connect(_toggle_destroy_mode)

func _toggle_build_mode(build: String):
  if Data.build_mode == Data.BuildModes.BUILD:
    remove_child(current_placement_building)
    current_placement_building.queue_free()
    Data.build_mode = Data.BuildModes.NONE
    if current_placement_building and current_placement_building.data.code_name != build:
      Data.build_mode = Data.BuildModes.BUILD
      current_placement_building = create_building(build)
      current_placement_building.position = get_snapped_mouse_pos()
      add_child(current_placement_building)
  else:
      Data.build_mode = Data.BuildModes.BUILD
      current_placement_building = create_building(build)
      current_placement_building.position = get_snapped_mouse_pos()
      add_child(current_placement_building)
  # if toggle_building: toggle_destroying = false

func _toggle_destroy_mode(_val: bool):
  # toggle_destroying = !toggle_building
  # if toggle_destroying: Data.build_mode = Data.BuildModes.NONE
  Data.build_mode = Data.BuildModes.DESTROY


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("a_key") and Data.build_mode == Data.BuildModes.BUILD:
    var at = data_grid.local_to_map(current_placement_building.position)
    if can_place_building(current_placement_building, at):
      place_building(current_placement_building, at)
      current_placement_building = create_building(current_placement_building.data.code_name)
      current_placement_building.position = get_snapped_mouse_pos()
      add_child(current_placement_building)
  elif event.is_action_pressed("a_key") and Data.build_mode == Data.BuildModes.DESTROY:
    pass



func _physics_process(_delta: float) -> void:
  if Data.build_mode == Data.BuildModes.NONE: pass;

  if Data.build_mode == Data.BuildModes.BUILD and is_instance_valid(current_placement_building):
    current_placement_building.position = get_snapped_mouse_pos()
    current_placement_building.toggle_cannot_build_shader(
      not can_place_building(
        current_placement_building, 
        data_grid.local_to_map(current_placement_building.position))
    )


func get_snapped_mouse_pos():
  var mouse_pos = world.get_local_mouse_position()
  var tile_pos = data_grid.local_to_map(mouse_pos) 
  var snapped_mouse_pos = tile_pos * data_grid.size
  return snapped_mouse_pos

func map_to_local(at: Vector2i):
  return data_grid.map_to_local(at)
func local_to_map(at: Vector2i):
  return data_grid.local_to_map(at)

func map_to_global(at: Vector2i):
  return data_grid.to_global(map_to_local(at))
func global_to_map(at: Vector2i):
  return local_to_map(data_grid.to_local(at))

func get_local_tile_center(at: Vector2i) -> Vector2i:
  return map_to_local(at) + data_grid.size

func get_building_scene_path(build: String):
  return "res://scenes/placeables/" + build + ".tscn"

func create_building(build: String):
  var building = buildings_prototypes[build].instantiate()
  return building

# `at` is relative to data_grid
func can_place_building(build: BuildingTemplate, at: Vector2i):
  var building_cells := get_building_tiles(data_grid, build, at)
  var has_collisions = false
  for cell in building_cells:
    if data_grid.data[cell]["is_used"]:
      has_collisions = true
      break
  if has_collisions:
    return false
  else:
    return true


func place_building(build: BuildingTemplate, at: Vector2i) -> void:
  var building_tiles = get_building_tiles(data_grid, build, at)
  # var building_pos = data_grid.to_local(build.global_position)
  var building_pos = building_tiles.map(func(tile): return data_grid.map_to_local(tile))
  var building_tile_origin = data_grid.local_to_map(building_pos[0])
  build.origin_tile = building_tile_origin

  for cell in building_tiles:
    data_grid.data[cell]["is_used"] = true  
    data_grid.data[cell]["building"] = build
    data_grid.data[cell]["building_cell"] = cell - building_tile_origin
    if build.data.type == "path":
      data_grid.data[cell]["is_walkable"] = true
      set_cell(cell, "path")
    else:
      set_cell(cell)
    if cell == building_tile_origin:
      build.position = building_pos[0] - Vector2(8, 8)
  if build.data.is_enterable:
    set_cell(get_map_entrance_tile(build, building_tile_origin), "entrance")
    build.entrance_tile = get_map_entrance_tile(build, building_tile_origin)
  else:
    build.entrance_tile = building_tile_origin
  Signals.store_building.emit(build)
  
func set_cell(cell: Vector2i, type: String = "building"):
  match type:
    "path":
      data_grid.set_cell(cell, 0, Vector2i(0,0))
    "entrance":
      data_grid.set_cell(cell, 0, Vector2i(0,0))
    _:
      data_grid.set_cell(cell, 0, Vector2i(0, 1))

  




func get_building_tiles(grid: TileMapLayer, building: BuildingTemplate, at: Vector2i) -> Array[Vector2i]:
  var build_dims = building.get_node("Sprite").get_rect().size
  var offset = Vector2(
    build_dims.x / building.data.cells.x,
    build_dims.y / building.data.cells.y
  )
  var build_cells: Array[Vector2i] = []
  for x in range(building.data.cells.x):
    for y in range(building.data.cells.x):
      build_cells.append(
        grid.local_to_map(map_to_local(at) + Vector2(x, y) * offset)
      )
  return build_cells

## start_tile is the tile of the first building node, so it can find the entrance relatively
func get_local_entrance_tile(build: BuildingTemplate, start_tile: Vector2i) -> Vector2i:
  var relative_tile = build.data.entrance_cell
  return map_to_local(relative_tile + start_tile)

## start_tile is the tile of the first building node, so it can find the entrance relatively
func get_map_entrance_tile(build: BuildingTemplate, start_tile: Vector2i) -> Vector2i:
  var relative_tile = build.data.entrance_cell
  return relative_tile + start_tile


func preload_building(build: String):
# for cell in get_used_cells():
#   tile_data[cell] = tile_data_template.duplicate()
#   var preloaded_data = get_cell_tile_data(cell)
#   if preloaded_data and preloaded_data.get_custom_data("Wall"):
#     tile_data[cell]["preloaded"] = true
#     var wall = BuildingFactory.create_building("decor/outer_wall")
#     wall.position = map_to_local(cell)
#     add_child(wall)
  for cell in data_grid.get_used_cells():
    var preloaded_data = data_grid.get_cell_tile_data(cell)
    if preloaded_data and preloaded_data.get_custom_data(build):
      var building = create_building(build)
      var building_tiles = get_building_tiles(data_grid, building, cell)
      var can_build_preload = true
      for preload_cell in building_tiles:
        if not data_grid.get_cell_tile_data(preload_cell) or not data_grid.get_cell_tile_data(preload_cell).get_custom_data(build):
          can_build_preload = false;
          break;

      if can_place_building(building, cell) and can_build_preload: 
        add_child(building)
        place_building( building, cell)
  

